Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076Ab3B0BhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:37:20 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17219 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab3B0BhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 20:37:18 -0500
X-IronPort-AV: E=Sophos;i="4.84,744,1355126400"; 
   d="scan'208";a="26748431"
Message-ID: <512D634D.5010600@codeaurora.org>
Date: Tue, 26 Feb 2013 17:37:17 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-arm-msm@vger.kernel.org, Steve Muckle <smuckle@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: vfp: fix fpsid register subarchitecture field mask
 width
References: <1361520485-30269-1-git-send-email-sboyd@codeaurora.org> <20130225172545.GO17833@n2100.arm.linux.org.uk> <20130225200209.GP17833@n2100.arm.linux.org.uk>
In-Reply-To: <20130225200209.GP17833@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/13 12:02, Russell King - ARM Linux wrote:
>
> This can of worms is getting bigger.  We have more problems with our
> handling of the different VFP versions, specifically the handling of
> the EX=0 DEX=0 case.
>
> VFP common subarch 3 defines the EX=0, DEX=0 encoding to mean one of
> the following conditions have been met:
>
> 1. an unallocated VFP instruction was encountered.
>
>    In other words, the VFP was the target of the co-processor instruction,
>    but the instruction is not a known VFP instruction encoding.  This
>    should raise an undefined instruction exception.
>
> 2. an allocated VFP instruction was encountered, but not handled in
>    hardware.
>
>    In other words, the instruction is a valid VFP instruction, but the
>    hardware has opted not to implement this instruction and wants
>    software to emulate it instead.
>
>    (Note: this can also be raised as EX=0, DEX=1 - implementation
>     defined!)
>
[snip]
>
> So, if EX or DEX is set, _or_ IXE is set, we pass control to VFP_bounce.
> This is problematical.
>
> (a) condition (2) above isn't correctly handled for common subarch v3 - it
>     is always treated as an undefined instruction, and will result in a
>     SIGILL being delivered.
>
[snip]
>
> Now, (a) is just bad behaviour - as we haven't had any reports of this
> yet, I suspect that no one has implemented VFP hardware with this
> behaviour yet.

I believe we ran into this a while ago and fixed it for our chips. We
never sent the patch upstream. Sorry.

https://www.codeaurora.org/gitweb/quic/la/?p=kernel/msm.git;a=commitdiff;h=00a13be874f230159a6b7f8cc9d0ff23bc1b7d05

I'm looking into what our bits correspond to. Hopefully get back to you
in 20 something hours.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

