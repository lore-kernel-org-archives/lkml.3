Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab3LZTlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 14:41:37 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:45763 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab3LZTlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 14:41:35 -0500
Date: Thu, 26 Dec 2013 11:41:33 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 4/7] mfd: ssbi: Add regmap read/write helpers
Message-ID: <20131226194133.GJ31766@codeaurora.org>
References: <1387831563-13535-1-git-send-email-sboyd@codeaurora.org>
 <1387831563-13535-5-git-send-email-sboyd@codeaurora.org>
 <20131224125443.GC30815@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131224125443.GC30815@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24, Mark Brown wrote:
> On Mon, Dec 23, 2013 at 12:46:00PM -0800, Stephen Boyd wrote:
> 
> > +int ssbi_reg_read(void *context, unsigned int reg, unsigned int *val)
> > +{
> > +	*val = 0;
> > +	return ssbi_read(context, reg, (u8 *)val, 1);
> > +}
> > +EXPORT_SYMBOL_GPL(ssbi_reg_read);
> > +
> > +int ssbi_reg_write(void *context, unsigned int reg, unsigned int val)
> > +{
> > +	return ssbi_write(context, reg, (u8 *)&val, 1);
> > +}
> > +EXPORT_SYMBOL_GPL(ssbi_reg_write);
> 
> Not a big deal but could these just be inlined in the headers?

Sure, I can do that if I need to resend? The only benefit I see
is two less symbols exported.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
