Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965519AbaFCQtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 12:49:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45215 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964958AbaFCQtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 12:49:18 -0400
Message-ID: <538DFC8A.9030806@wwwdotorg.org>
Date: Tue, 03 Jun 2014 10:49:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: fwu@marvell.com, linus.walleij@linaro.org, tony@atomide.com
CC: linux-kernel@vger.kernel.org, swarren@nvidia.com, cxie4@marvell.com,
        ylmao@marvell.com, njiang1@marvell.com, tianxf@marvell.com,
        fswu@marvell.com
Subject: Re: [PATCH v4] pinctrl: to avoid duplicated calling enable_pinmux_setting
 for a pin
References: <1401781077-31150-1-git-send-email-fwu@marvell.com>
In-Reply-To: <1401781077-31150-1-git-send-email-fwu@marvell.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2014 01:37 AM, fwu@marvell.com wrote:
> From: Fan Wu <fwu@marvell.com>
> 
> What the patch did:
> 1.To call pinmux_disable_setting ahead of pinmux_enable_setting in each time of
>   calling pinctrl_select_state
> 2.Remove the HW disable operation in in pinmux_disable_setting function.
> 3.Remove the disable ops in struct pinmux_ops
...
> Signed-off-by: Fan Wu <fwu@marvell.com>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

As I mentioned in my previous email, I didn't sign this off. I made some
suggestions for a better alternative in that email.

If I *had* written that s-o-b, then it should be before yours in the
patch description since you handled the patch last.

> diff --git a/include/linux/pinctrl/pinmux.h b/include/linux/pinctrl/pinmux.h

> @@ -70,8 +70,6 @@ struct pinmux_ops {
>  				  unsigned * const num_groups);
>  	int (*enable) (struct pinctrl_dev *pctldev, unsigned func_selector,
>  		       unsigned group_selector);
> -	void (*disable) (struct pinctrl_dev *pctldev, unsigned func_selector,
> -			 unsigned group_selector);

This will cause a compile failure, since many drivers still set the
.disable function pointer. You need to update all the driver files to
remove those functions too. There's quite a bit of code in some of those
functions, so you'd need the relevant driver maintainers to confirm it's
OK to remove it. I think only the owners of pinctrl-egra and
pinctrl-single have ack'd this concept so far.
