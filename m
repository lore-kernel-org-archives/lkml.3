Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbbAIQqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 11:46:17 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55956 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752014AbbAIQqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 11:46:16 -0500
Date: Fri, 9 Jan 2015 16:46:08 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH] arm: Remove early stack deallocation from
 restore_user_regs
Message-ID: <20150109164608.GV12302@n2100.arm.linux.org.uk>
References: <1418382718-16323-1-git-send-email-daniel.thompson@linaro.org>
 <1420470758-5874-1-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420470758-5874-1-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 03:12:38PM +0000, Daniel Thompson wrote:
> Currently restore_user_regs deallocates the SVC stack early in
> its execution and relies on no exception being taken between
> the deallocation and the registers being restored. The introduction
> of a default FIQ handler that also uses the SVC stack breaks this
> assumption and can result in corrupted register state.
> 
> This patch works around the problem by removing the early
> stack deallocation and using r2 as a temporary instead. I have
> not found a way to do this without introducing an extra mov
> instruction to the macro.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> ---

Please put it in the patch system, thanks.  I think we should queue
this one for stable too, as I think we need this for v3.18
(as a result of c0e7f7ee717e2b4c5791e7422424c96b5008c39e,
ARM: 8150/3: fiq: Replace default FIQ handler)?

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
