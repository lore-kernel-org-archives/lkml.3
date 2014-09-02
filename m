Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbaIBSvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 14:51:43 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40882 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754751AbaIBSvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 14:51:41 -0400
Date: Tue, 2 Sep 2014 19:51:27 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH v11 01/19] arm: fiq: Add callbacks to manage FIQ
	routings
Message-ID: <20140902185127.GV30401@n2100.arm.linux.org.uk>
References: <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org> <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org> <1409662853-29313-2-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409662853-29313-2-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 02:00:35PM +0100, Daniel Thompson wrote:
>  void enable_fiq(int fiq)
>  {
> +	struct fiq_data *data = lookup_fiq_data(fiq);
> +
> +	if (data) {
> +		if (data->fiq_chip->fiq_enable)
> +			data->fiq_chip->fiq_enable(data->irq_data);
> +		enable_irq(fiq);

Why do we call the FIQ chip's enable and enable_irq() as well?

>  void disable_fiq(int fiq)
>  {
> +	struct fiq_data *data = lookup_fiq_data(fiq);
> +
> +	if (data) {
> +		if (data->fiq_chip->fiq_disable)
> +			data->fiq_chip->fiq_disable(data->irq_data);
> +		disable_irq(fiq);

Same question here.

> +bool has_fiq(int fiq)
> +{
> +	struct fiq_data *data = lookup_fiq_data(fiq);
> +
> +	if (data)
> +		return true;
> +
> +	if (fiq_start == -1)
> +		return false;
> +
> +	return fiq >= fiq_start;

Are you sure this is correct... it looks wrong to me.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
