Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbaAAMhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 07:37:52 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:39155 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbaAAMhv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 07:37:51 -0500
X-Auth-Info: VBzqQo8iKe/yxy7YKLx880BbD1DfrKu+xmapZi6GFU8=
Date: Wed, 1 Jan 2014 13:37:46 +0100
From: Gerhard Sittig <gsi@denx.de>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Christian Hohnstaedt <chohnstaedt@innominate.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [ARM] Fix kernel compile error: drivers/crypto/ixp4xx_crypto.c.
Message-ID: <20140101123746.GB20094@book.gsilab.sittig.org>
References: <m3d2kduwd7.fsf@t19.piap.pl>
 <20131231134820.GS8064@book.gsilab.sittig.org>
 <52C3066E.1070909@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <52C3066E.1070909@infradead.org>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 31, 2013 at 10:01 -0800, Randy Dunlap wrote:
> 
> On 12/31/13 05:48, Gerhard Sittig wrote:
> > On Tue, Dec 31, 2013 at 11:51 +0100, Krzysztof Hałasa wrote:
> >>
> >> drivers/crypto/ixp4xx_crypto.c: In function 'ixp_module_init':
> >> drivers/crypto/ixp4xx_crypto.c:1419:2: error: 'dev' undeclared (first use in this function)
> >>
> >> Now builds. Not tested on real hw.
> >>
> >> Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>
> > 
> > I understood that a 'Fixes: <hash> <subject>' line is suggested when
> > you can clearly identify what broke what you fix.  Is it 27c1789ca6a6
> > "DMA-API: crypto: remove last references to 'static struct device *dev'"?
> > Then v3.13-rc1 would have been affected.
>  
> is 'Fixes: <whatever>' documented somewhere?

Last time I checked (few days ago, 'git grep -w Fixes:') it
wasn't, at least not within the kernel source tree and its
Documentation hierarchy.  Today's master still does not have it.

But a quick search in recent LAKML messages reveals that it's
been in use by e.g. Olof Johansson, Jason Cooper, Rusty Russell,
Dan Carpenter, Russell King, Mark Brown, Stephen Warren, Paul
Walmsley, and I'm not making this up but am just referring to
what repeatedly was requested in the past.  The form used there
was "Fixes: <hash> (<oneline>)" though.  A doc update may be due
to have a canonical format.

I do see the benefit of this tag, as it does not hide this
information in the commit message's prose, makes submitters think
about that property in more explicit ways and makes them provide
the information such that others need not do the research, and
greatly helps those involved in tests and release management to
determine affected versions and required actions that need to be
taken.  The tag is very useful.


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
