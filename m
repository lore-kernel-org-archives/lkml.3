Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab3FCVdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 17:33:52 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:41505 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab3FCVdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 17:33:47 -0400
Date: Mon, 3 Jun 2013 17:33:45 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: avoid mis-detecting some V7 cores in the
 decompressor
In-Reply-To: <51AD0703.6050408@codeaurora.org>
Message-ID: <alpine.LFD.2.03.1306031726410.1200@syhkavp.arg>
References: <1368049671-22879-1-git-send-email-sboyd@codeaurora.org> <5193E424.9090605@codeaurora.org> <519E57D2.3050000@codeaurora.org> <20130523231531.GT18614@n2100.arm.linux.org.uk> <20130524220539.GB599@codeaurora.org> <51AD0703.6050408@codeaurora.org>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 05/24/13 15:05, Stephen Boyd wrote:
> > I see a few solutions.
> >
> >  1) Relocate with caches off and then turn on caches after we're
> >     running in a location where we won't overwrite ourselves.

Due to the cost of doing memory copy with the cache off, thisoption 
should be conditionally used and only when there is an actual conflict.

> >  2) Have temporary page tables for the relocation phase that live
> >     just below the location we're going to relocate to.
> >
> >  3) Force bootloaders loading these types of images to load the
> >     zImage at least as high as the TEXT_OFFSET is compiled to.
> >
> > I don't think we can convince everyone that #3 is ok to do. I'm
> > leaning towards #2 since we get all the benefits of the cache
> > during the relocation phase but #1 is the obviously simple fix.

I'd consider #2 too.


Nicolas
