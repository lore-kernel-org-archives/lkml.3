Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab3JAS0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 14:26:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46618 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab3JAS0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 14:26:13 -0400
Message-ID: <524B13BF.7080902@wwwdotorg.org>
Date: Tue, 01 Oct 2013 12:26:07 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Tony Lindgren <tony@atomide.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        openezx-devel@lists.openezx.org, linux-samsung-soc@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] pwm-backlight: Refactor backlight power on/off
References: <1379972467-11243-1-git-send-email-treding@nvidia.com> <1379972467-11243-2-git-send-email-treding@nvidia.com>
In-Reply-To: <1379972467-11243-2-git-send-email-treding@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 03:40 PM, Thierry Reding wrote:
> In preparation for adding an optional regulator and enable GPIO to the
> driver, split the power on and power off sequences into separate
> functions to reduce code duplication at the multiple call sites.

> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c

> +static void pwm_backlight_power_off(struct pwm_bl_data *pb)
> +{
> +	pwm_disable(pb->pwm);

Both the call-sites you're replacing do the following before pwm_disable():

		pwm_config(pb->pwm, 0, pb->period);

While I agree that probably shouldn't be necessary, I think it's at
least worth mentioning that in the commit description just to make it
obvious that it was a deliberate change. Splitting that change into a
separate patch might be reasonable in order to keep refactoring and
functional changes separate, although perhaps it's not worth it.

There are also a couple unrelated whitespace changes thrown in here.
