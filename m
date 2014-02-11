Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaBKQ1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:27:52 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:34798 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbaBKQ1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:27:50 -0500
Date: Tue, 11 Feb 2014 16:27:43 +0000
From: Lee Jones <lee.jones@linaro.org>
To: "Anthony Olech <anthony.olech.opensource@diasemi.com>" 
	<Anthony.Olech.OpenSource@diasemi.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [PATCH V2] mfd: da9052: Fix volatile register definition
 ommissions
Message-ID: <20140211162743.GC15081@lee--X1>
References: <201402111611.s1BGBXkr056672@swsrvapps-02.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201402111611.s1BGBXkr056672@swsrvapps-02.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Feb 2014, Anthony Olech <anthony.olech.opensource@diasemi.com> wrote:

> Three of the PMIC registers have some bits that are changed
> autonomously by the PMIC itself (some time) after being set
> by some component driver of the DA9052 PMIC and hence they
> need to be marked as volatile so that the regmap API will
> not cache their values.
> 
> Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> Acked-by: David Dajun Chen <david.chen@diasemi.com>
> ---
> 
> This patch is relative to linux-next repository tag next-20140206
> 
> The problem was detected whilst running a scripted set of functional
> regression tests whilst investigating a different problem.
> 
> This patch has been test compiled on an amd64 server for both x86
> and arm targets.
> 
> This patch has been spot verified using an SMDK6410 platform
> fly-wired to a Dialog da9053 EVB.
> 
> The bug that this patch fixes affects two components of DA9052 namely:
> 
> WATCHDOG - the first kick will work but sebsequent ones will not
>            thus the watchdog will timeout at 2 x interval.
> 
> REGULATORS - the first change to any DA9052/DA9053  BUCK voltage
>              will be actioned, but sebsequent ones will not.
> 
>  drivers/mfd/da9052-core.c |    3 +++
>  1 file changed, 3 insertions(+)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
