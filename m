Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab3LXMy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 07:54:56 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48359 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab3LXMyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 07:54:54 -0500
Date: Tue, 24 Dec 2013 12:54:43 +0000
From: Mark Brown <broonie@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20131224125443.GC30815@sirena.org.uk>
References: <1387831563-13535-1-git-send-email-sboyd@codeaurora.org>
 <1387831563-13535-5-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387831563-13535-5-git-send-email-sboyd@codeaurora.org>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 81.132.50.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 4/7] mfd: ssbi: Add regmap read/write helpers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 12:46:00PM -0800, Stephen Boyd wrote:

> +int ssbi_reg_read(void *context, unsigned int reg, unsigned int *val)
> +{
> +	*val = 0;
> +	return ssbi_read(context, reg, (u8 *)val, 1);
> +}
> +EXPORT_SYMBOL_GPL(ssbi_reg_read);
> +
> +int ssbi_reg_write(void *context, unsigned int reg, unsigned int val)
> +{
> +	return ssbi_write(context, reg, (u8 *)&val, 1);
> +}
> +EXPORT_SYMBOL_GPL(ssbi_reg_write);

Not a big deal but could these just be inlined in the headers?
