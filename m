Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab3IQXZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 19:25:12 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:65194 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab3IQXZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 19:25:10 -0400
MIME-Version: 1.0
X-Originating-IP: [208.54.5.211]
In-Reply-To: <1379459060.6148.10.camel@pasglop>
References: <1379300274.4098.77.camel@pasglop>
	<5238C4D1.6060500@gmail.com>
	<CAOesGMh0F09OAR4bepGSCE5Z5OZ56fBmDPBSfwZ+NB9RgcE0Vw@mail.gmail.com>
	<2179723.s3DLWi0P8b@flatron>
	<CAOesGMjt6RsvYRjXxpB=v-Ro6iyUN=YzkDd1mfHqCDJJDRJvLg@mail.gmail.com>
	<1379459060.6148.10.camel@pasglop>
Date: Tue, 17 Sep 2013 16:25:08 -0700
Message-ID: <CAOesGMhzc=BCDBYcidKHhFbwuD1r4R2ePbdYRCTgX2USdXPnRQ@mail.gmail.com>
Subject: Re: "memory" binding issues
From: Olof Johansson <olof@lixom.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, Frank Rowand <frowand.list@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Stephen Warren <swarren@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 4:04 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Tue, 2013-09-17 at 14:33 -0700, Olof Johansson wrote:
>> > I don't think it's broken, why do you think so? It's at least
>> consistent.
>> > Probably not perfect and not complete, but IMHO a reasonable base
>> for
>> > further work. (Also at least something written down that people can
>> learn
>> > from and/or refer to.)
>>
>> So, I stand corrected. It seems that at least one legacy system I'm
>> looking at always specifies unit address as well. I don't like it but
>> I'll stop arguing.
>>
>> Ben: The interesting part is that it does _not_ specify it on /memory
>> though. Nor, of course, on /cpus or /openprom. So assuming /memory@0
>> exists will break even on some powerpc platforms.
>
> What system is that out of curiosity ? Also make sure it's not just
> Linux being an idiot and stripping the @0 in /proc/device-tree ...
>
> (I think some old versions of /proc code would strip it)
>
> Or is that some insanely broken OF like Apple old world or Pegasos ?
>
> If it's just embedded .dts files, yes, I fixed some, but we might still
> have some bad ones.

The only powerpc hardware I still have these days is PA Semi systems,
so it's from one of them, with current -next kernel. Booted with OF
client interface, no dts file that can be fixed.

> In any case, we all agree, the right thing to do first is to fix our
> path parser to cope either way.

Yep, I just wanted to alert you that there's powerpc systems out there
with just /memory as well.


-Olof
