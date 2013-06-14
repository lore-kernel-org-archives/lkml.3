Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab3FNSAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 14:00:06 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44197 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab3FNSAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 14:00:03 -0400
Date: Fri, 14 Jun 2013 11:00:01 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] ARM: mmu: Add debug_ll_io_init() mappings to early
 mappings
Message-ID: <20130614180001.GB3399@codeaurora.org>
References: <1371000607-1787-1-git-send-email-sboyd@codeaurora.org>
 <CAL_JsqLJ7ZD9-VR+vgOZZ_q-RD6FCDvKPSNSCjAADxy94SU1Xg@mail.gmail.com>
 <20130612172146.GB10823@codeaurora.org>
 <51BB15DA.8020302@gmail.com>
 <20130614164524.GA3399@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130614164524.GA3399@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14, Stephen Boyd wrote:
> On 06/14, Rob Herring wrote:
> > On 06/12/2013 12:21 PM, Stephen Boyd wrote:
> > > On 06/11, Rob Herring wrote:
> > >> Can you use vm_reserve_area_early here or perhaps just call
> > >> iotable_init instead of create_mapping directly? I don't recall if
> > >> there was some reason I didn't do that.
> > >>
> > > 
> > > I had iotable_init() before but I thought it was better to have
> > > the ->caller argument say debug_ll_io_init() instead of
> > > iotable_init(). Shall I extract out the similar code?
> > 
> > Well, that's always welcome...
> > 
> > Another option would be use __builtin_return_address. That would change
> > vmallocinfo from showing iotable_init to the caller of iotable_init.
> > Arguably, knowing the caller would be better.
> > 
> 
> Ok sounds fair. I'll use iotable_init() and send a follow-up
> patch to make iotable_init() more informative.
> 

Well now I get paging_init() as the function because that's where
we're going to return to. That actually seems less informative.
I'll do the similar code extraction.
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
