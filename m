Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaBKTBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:01:14 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:35122 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaBKTBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:01:11 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2 1/5] drivers: of: add initialization code for reserved memory
To: Tomasz Figa <t.figa@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@gmail.com>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>
In-Reply-To: <52FA33E2.4050004@samsung.com>
References: <1391515773-6112-1-git-send-email-m.szyprowski@samsung.com> < 1391515773-6112-2-git-send-email-m.szyprowski@samsung.com> <20140205110538. 99E47C40A89@trevor.secretlab.ca> <52FA0D6E.9090304@samsung.com> < 20140211121316.24032C40C4D@trevor.secretlab.ca> <52FA33E2.4050004@samsung. com>
Date: Tue, 11 Feb 2014 19:01:04 +0000
Message-Id: <20140211190104.7E6C5C4140E@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014 15:29:54 +0100, Tomasz Figa <t.figa@samsung.com> wrote:
> > Yes, if only because it is an define usage of the reg property. If a
> > devtree has multiple tuples in reg, then all of those tuples should be
> > treated as reserved, even if the kernel doesn't know how to use them.
> >
> > I would not do the same for size/align/alloc-ranges unless there is a
> > very specific use case that you can define. These ones are different
> > from the static regions because they aren't ever used to protect
> > something that already exists in the memory.
> 
> Is there a reason why multiple regions could not be used for this 
> purpose, instead of adding extra complexity of having multiple reg 
> entries per region?
> 
> I.e. I don't see a difference between
> 
> reg1: region@00000000 {
> 	reg = <0x00000000 0x1000>;
> };
> 
> reg2: region@10000000 {
> 	reg = <0x10000000 0x1000>;
> };
> 
> user {
> 	regions = <&reg1>, <&reg2>;
> };
> 
> and
> 
> reg: region@00000000 {
> 	reg = <0x00000000 0x1000>, <0x10000000 0x1000>;
> };
> 
> user {
> 	regions = <&reg>;
> };
> 
> except that the former IMHO better suits the definition of memory 
> region, which I see as a single contiguous range of memory and can be 
> simplified to have a single reg entry per region.

My point is rather if multiple reg tuples are found in a reserved memory
node, the kernel must respect them and reserve the memory. I'm not
arguing about whether or not that makes for a good binding.

g.

