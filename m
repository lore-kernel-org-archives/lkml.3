Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbaIEOor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:44:47 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:18679 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbaIEOoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:44:46 -0400
Message-ID: <5409CC39.3060608@oracle.com>
Date: Fri, 05 Sep 2014 10:44:09 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
CC: Joe Perches <joe@perches.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        akpm@linuxfoundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: add support for gcc 5
References: <1409845039-5751-1-git-send-email-sasha.levin@oracle.com>		 <20140904212535.GA5059@drone.musicnaut.iki.fi>		 <1409870628.2310799.163815377.623F33D2@webmail.messagingengine.com>	 <1409874455.2770.26.camel@joe-AO725> <54092FE0.3030004@oracle.com> <1409890133.10788.23.camel@localhost>
In-Reply-To: <1409890133.10788.23.camel@localhost>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 12:08 AM, Hannes Frederic Sowa wrote:
> On Do, 2014-09-04 at 23:37 -0400, Sasha Levin wrote:
>> > On 09/04/2014 07:47 PM, Joe Perches wrote:
>>> > > On Fri, 2014-09-05 at 00:43 +0200, Hannes Frederic Sowa wrote:
>>>>> > >> > Most statements are already depending on GCC_VERSION, maybe we can just
>>>>> > >> > unify all gcc specific headers to one, still trying to keep the file
>>>>> > >> > organized? ;)
>>> > > Maybe something like:
>>> > > 
>>> > > gnu development of gcc will be more frequent and the use of
>>> > > compiler-gcc<major>.h likely will not be convenient anymore.
>>> > > 
>>> > > Integrate the individual compiler-gcc<major>.h files into
>>> > > compiler-gcc.h.
>> > 
>> > Please no. We have a similar file we maintain in our team that's supposed to
>> > do something very similar for kernel versions. It goes all the way back to
>> > 2.6.9 and it's a *horrible* mess.
>> > 
>> > This is how compiler-gcc.h will end up looking in a while.
> Something along these lines? We can make '4' a macro describing it
> references the latest possible compiler-gccX.h file.

I agree, something along those lines would be great. We'd still have
all this mess split into smaller headers and we won't be forced to add
compiler-gccX.h until we actually need it.

The problem it causes is that if you want to figure out what specific line
of code in one of those headers affects your kernel you may need to browse
through multiple headers (-gcc3.h ... -gccX.h) but I suspect that we won't
have too many conflicting declarations, as Joe pointed out - they are mostly
upward compatible.


Thanks,
Sasha
