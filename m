Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbaDCUtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 16:49:23 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:50555 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753541AbaDCUtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 16:49:21 -0400
Message-ID: <1396558159.21212.4.camel@x220>
Subject: Re: [PATCH] mach-bcm: clean up config and build targets
From: Paul Bolle <pebolle@tiscali.nl>
To: Alex Elder <elder@linaro.org>
Cc: bcm@fixthebug.org, mporter@linaro.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 03 Apr 2014 22:49:19 +0200
In-Reply-To: <1396557052-24029-1-git-send-email-elder@linaro.org>
References: <1396557052-24029-1-git-send-email-elder@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Apr 2014 20:49:19.0393 (UTC) FILETIME=[2F3B6910:01CF4F7E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-03 at 15:30 -0500, Alex Elder wrote:
> Currently CONFIG_ARCH_BCM_MOBILE is used to select all Broadcom
> mobile SoCs.  Instead, use that only as a config menu switch, and
> define specific symbols like CONFIG_ARCH_BCM_281XX to select a
> particular SoC family.  If ARCH_BCM_MOBILE is selected, all of the
> SoCs will be selected by default, but this way each can be disabled
> individually as well.
> 
> This allows more precision in controlling what gets built under
> mach-bcm.  Another benefit to doing this is that it makes it obvious
> that the code that implements SMC calls to control L2 cache is only
> used for BCM281XX (for example).
> 
> Also use Kbuild's $(<modulename>-y) variable mechanism to build a
> single object file containing everything used for the bcm281xx board
> in arch/arm/mach-bcm.
> 
> Note:  This patch is based on the current arm-soc/for-next branch:
>     e98cd72 arm-soc: document samsung merges
> 
> The patch is available here:
>     http://git.linaro.org/landing-teams/working/broadcom/kernel.git
>     Branch review/mach-bcm-cleanup

It seems the last two paragraphs should actually be below the "---"
marker. There's no need to include them in the commit explanation, is
there?

> Signed-off-by: Alex Elder <elder@linaro.org>
> ---


Paul Bolle

