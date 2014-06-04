Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbaFDJqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 05:46:43 -0400
Received: from mx0.aculab.com ([213.249.233.131]:53639 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751746AbaFDJql convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 05:46:41 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Julia Lawall'" <julia.lawall@lip6.fr>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-rdma <linux-rdma@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        "iss_storagedev@hp.com" <iss_storagedev@hp.com>,
        scsi <linux-scsi@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        "adi-buildroot-devel@lists.sourceforge.net" 
	<adi-buildroot-devel@lists.sourceforge.net>
Subject: RE: [PATCH 0/10] use safer test on the result of find_first_zero_bit
Thread-Topic: [PATCH 0/10] use safer test on the result of
 find_first_zero_bit
Thread-Index: AQHPf9jD3P2Wp/I7I0O0KpvEWFb8KZtgszAA
Date: Wed, 4 Jun 2014 09:46:17 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1725705F@AcuExch.aculab.com>
References: <1401872880-23685-1-git-send-email-Julia.Lawall@lip6.fr>
 <CAMuHMdXsoFUXj4jLMWN6NY7Um19KwWO9Rhx=9=gqWu_K5Ev2kQ@mail.gmail.com>
 <alpine.DEB.2.10.1406041137270.2441@hadrien>
In-Reply-To: <alpine.DEB.2.10.1406041137270.2441@hadrien>
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

From: Julia Lawall
> On Wed, 4 Jun 2014, Geert Uytterhoeven wrote:
> 
> > Hi Julia,
> >
> > On Wed, Jun 4, 2014 at 11:07 AM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> > > Find_first_zero_bit considers BITS_PER_LONG bits at a time, and thus may
> > > return a larger number than the maximum position argument if that position
> > > is not a multiple of BITS_PER_LONG.
> >
> > Shouldn't this be fixed in find_first_zero_bit() instead?
> 
> OK, I could do that as well.  Most of the callers currently test with >=.
> Should they be left as is, or changed to use ==?

Do we want to add an extra test to find_first_zero_bit() and effectively
slow down all the calls - especially those where the length is a
multiple of 8 (probably the most common).

Maybe the documented return code should be changed to allow for the
existing behaviour.

	David



