Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933378AbaFKR3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:29:12 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:58345 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaFKR3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:29:08 -0400
Message-ID: <539891D0.8090309@gmail.com>
Date: Wed, 11 Jun 2014 19:28:48 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tushar Behera <tushar.b@samsung.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: mturquette@linaro.org, t.figa@samsung.com, linux@arm.linux.org.uk,
        galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        kgene.kim@samsung.com, khilman@linaro.org, dianders@google.com,
        trblinux@gmail.com, Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: Re: [PATCH 1/3] clk: exynos-audss: Keep the parent of mout_audss
 always enabled
References: <1402464739-19044-1-git-send-email-tushar.b@samsung.com> <1402464739-19044-2-git-send-email-tushar.b@samsung.com>
In-Reply-To: <1402464739-19044-2-git-send-email-tushar.b@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tushar,

On 11.06.2014 07:32, Tushar Behera wrote:
> When the output clock of AUDSS mux is disabled, we are getting kernel
> oops while doing a clk_get() on other clocks provided by AUDSS. Though
> user manual doesn't specify this dependency, we came across this issue
> while disabling the parent of AUDSS mux clocks.

Could you provide more data about this oops? E.g. kernel log, platforms
it affects (just peach-pit or also others), test case, extra patches
applied on top of mainline (if any).

I don't like this solution, because keeping a clock always enabled is
usually not desirable and this driver is also used on other platforms
than peach-pit, so this change will affect all of them.

Best regards,
Tomasz
