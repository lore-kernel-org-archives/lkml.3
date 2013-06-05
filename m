Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab3FEXPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 19:15:25 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:58133 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250Ab3FEXPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 19:15:23 -0400
Date: Wed, 5 Jun 2013 16:15:17 -0700
From: Tejun Heo <tj@kernel.org>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        grant.likely@linaro.org, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 2/2] sata highbank: add bit-banged SGPIO driver support
Message-ID: <20130605231517.GP10693@mtj.dyndns.org>
References: <1369945051-2582-2-git-send-email-mark.langsdorf@calxeda.com>
 <1370471508-30806-1-git-send-email-mark.langsdorf@calxeda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370471508-30806-1-git-send-email-mark.langsdorf@calxeda.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jun 05, 2013 at 05:31:48PM -0500, Mark Langsdorf wrote:
> +static void ecx_parse_sgpio(struct ecx_plat_data *pdata, u32 port, u32 state)
> +{
> +	if (state & ECX_ACTIVITY_BITS)
> +		pdata->sgpio_pattern |= sgpio_bit_shift(pdata, port,
> +						ECX_ACTIVITY_SHIFT);
> +	else
> +		pdata->sgpio_pattern &= sgpio_bit_shift(pdata, port,
> +						ECX_ACTIVITY_SHIFT);

Shouldn't it be "&= ~" instead of "&="?  You're trying to turn the bit
off, right?

Looks okay to me otherwise.

Thanks.

-- 
tejun
