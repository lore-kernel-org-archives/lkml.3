Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab3IQXEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 19:04:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:44372 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435Ab3IQXEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 19:04:43 -0400
Message-ID: <1379459060.6148.10.camel@pasglop>
Subject: Re: "memory" binding issues
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Olof Johansson <olof@lixom.net>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, frowand.list@gmail.com,
        Stephen Warren <swarren@wwwdotorg.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Stephen Warren <swarren@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 18 Sep 2013 09:04:20 +1000
In-Reply-To: <CAOesGMjt6RsvYRjXxpB=v-Ro6iyUN=YzkDd1mfHqCDJJDRJvLg@mail.gmail.com>
References: <1379300274.4098.77.camel@pasglop> <5238C4D1.6060500@gmail.com>
	 <CAOesGMh0F09OAR4bepGSCE5Z5OZ56fBmDPBSfwZ+NB9RgcE0Vw@mail.gmail.com>
	 <2179723.s3DLWi0P8b@flatron>
	 <CAOesGMjt6RsvYRjXxpB=v-Ro6iyUN=YzkDd1mfHqCDJJDRJvLg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-17 at 14:33 -0700, Olof Johansson wrote:
> > I don't think it's broken, why do you think so? It's at least
> consistent.
> > Probably not perfect and not complete, but IMHO a reasonable base
> for
> > further work. (Also at least something written down that people can
> learn
> > from and/or refer to.)
> 
> So, I stand corrected. It seems that at least one legacy system I'm
> looking at always specifies unit address as well. I don't like it but
> I'll stop arguing.
> 
> Ben: The interesting part is that it does _not_ specify it on /memory
> though. Nor, of course, on /cpus or /openprom. So assuming /memory@0
> exists will break even on some powerpc platforms.

What system is that out of curiosity ? Also make sure it's not just
Linux being an idiot and stripping the @0 in /proc/device-tree ...

(I think some old versions of /proc code would strip it)

Or is that some insanely broken OF like Apple old world or Pegasos ?

If it's just embedded .dts files, yes, I fixed some, but we might still
have some bad ones. 

In any case, we all agree, the right thing to do first is to fix our
path parser to cope either way.

Cheers,
Ben.


