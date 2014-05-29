Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbaE2IhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:37:20 -0400
Received: from mx0.aculab.com ([213.249.233.131]:33798 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756551AbaE2IhQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:37:16 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Joe Perches'" <joe@perches.com>, Cody P Schafer <dev@codyps.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: RE: [PATCH 11/16] byteorder: provide a linux/byteorder.h with {be,
 le}_to_cpu() and cpu_to_{be, le}() macros
Thread-Topic: [PATCH 11/16] byteorder: provide a linux/byteorder.h with {be,
 le}_to_cpu() and cpu_to_{be, le}() macros
Thread-Index: AQHPehtRSTTppVgBd0OVC+FRTYrw6JtVrLPQgADQNQCAAAHCgIAADZSAgACwchA=
Date: Thu, 29 May 2014 08:36:11 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1724FA5C@AcuExch.aculab.com>
References: <1401236684-10579-1-git-send-email-dev@codyps.com>
	 <1401236684-10579-12-git-send-email-dev@codyps.com>
	 <063D6719AE5E284EB5DD2968C1650D6D1724EEAF@AcuExch.aculab.com>
	 <CAPoQQ-17OHotfbczJvEoq=vAzu_+6-sV3M1ZAhDaQ45wB3NB4A@mail.gmail.com>
	 <CAPoQQ-11vW3Q0=LcS-myNZ6hXeYBeu==_prwHJXHvLfkUSmZHQ@mail.gmail.com>
 <1401318025.19335.15.camel@joe-AO725>
In-Reply-To: <1401318025.19335.15.camel@joe-AO725>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches
> On Wed, 2014-05-28 at 17:11 -0500, Cody P Schafer wrote:
> > On Wed, May 28, 2014 at 5:05 PM, Cody P Schafer <dev@codyps.com> wrote:
> > > On Wed, May 28, 2014 at 3:45 AM, David Laight <David.Laight@aculab.com> wrote:
> > >> From: Cody P Schafer
> > >>> Rather manually specifying the size of the integer to be converted, key
> > >>> off of the type size. Reduces duplicate size info and the occurance of
> > >>> certain types of bugs (using the wrong sized conversion).
> > >> ...
> > >>> +#define be_to_cpu(v) \
> > >>> +     __builtin_choose_expr(sizeof(v) == sizeof(uint8_t) , v, \
> > >>> +     __builtin_choose_expr(sizeof(v) == sizeof(uint16_t), be16_to_cpu(v), \
> > >>> +     __builtin_choose_expr(sizeof(v) == sizeof(uint32_t), be32_to_cpu(v), \
> > >>> +     __builtin_choose_expr(sizeof(v) == sizeof(uint64_t), be64_to_cpu(v), \
> > >>> +             (void)0))))
> > >> ...
> > >>
> > >> I'm not at all sure that using the 'size' of the constant will reduce
> > >> the number of bugs - it just introduces a whole new category of bugs.
> > >
> > > Certainly, if you mis-size the argument (and thus have missized one of
> > > the variables containing the be value, probably a bug anyhow), there
> > > will be problems.
> > >
> > > I put this interface together because of an actual bug I wrote into
> > > the initial code of the hv_24x7 driver (resized a struct member
> > > without adjusting the be*_to_cpu() sizing).
> > > Having this "auto sizing" macro means I can avoid encoding the size of
> > > a struct field in multiple places.
> >
> > To clarify, the point I'm making here is that this simply cuts out 1
> > more place we can screw up endianness conversion sizing.
> 
> It does screw up other types when you do things like:
> 
> 	u8 foo = some_function();
> 
> 	cpu_to_be(foo + 1);
> 
> the return value is sizeof(int) not u8

And you'd have to be very, very careful with constants:
#define SOME_CONST xxxxx
	cp_to_be(SOME_CONST)
isn't likely to be the right size.

	David



