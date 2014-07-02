Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbaGBPiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:38:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57224 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264AbaGBPiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:38:54 -0400
Message-ID: <53B4277B.9070707@ti.com>
Date: Wed, 2 Jul 2014 21:08:35 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <merez@codeaurora.org>
CC: <noag@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Specific PHYs operation for phy-core
References: <7e6c972220e74f67cedd3aa55d61113c.squirrel@www.codeaurora.org>
In-Reply-To: <7e6c972220e74f67cedd3aa55d61113c.squirrel@www.codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 20 June 2014 02:38 AM, merez@codeaurora.org wrote:
> Hi,
> 
> We would like to use the phy-core framework for the UFS PHY implementation
> and we would appreciate your help with the following questions:
> 1. Our initialization sequence includes going back and forth operations
> between the core and the PHY. Due to that, the "init" function alone
> cannot hold the complete initialization sequence.
> The options we could think of are either add pre_init and post_init
> functions or add PHY specific functions.

pre-init and post-init seems to be too generic to be used. Would like 'ops'
that is more clearly defined (like 'reset' ops or 'calibrate' ops apart from
other existing ones where you know what should be done in the callback). If you
can explain what exact operations you are talking about we can see if it can be
fit in any existing or new generic ops.
> How do you recommend to resolve such a case?
> Have you thought about a way to expose PHY specific functions?

Exposing PHY specific functions are not recommended (since it is like ioctl)
and can be abused easily.
> 
> 2. Our core needs to check if the PCS (Physical Coding Sublayer) is ready
> as part of its flow. As this is a term that is present in almost all the
> serial PHYs, can we add is_pcs_ready() API to the generic PHY ops?
> If not, how do you recommend to resolve this?

yeah, was thinking about adding states to PHY since it looks to have other uses
apart from your use case. Something like PHY_STATE_DEFAULT, PHY_STATE_INIT,
PHY_STATE_POWERED, PHY_STATE_READY etc.. Then we can have phy_get_state to see
if the PHY is ready or not.
> 
> I would appreciate your prompt response as we would like to close the
> design by Monday.

ah.. sorry.

Cheers
Kishon
