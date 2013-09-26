Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab3IZPid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:38:33 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34710 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab3IZPic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:38:32 -0400
Message-ID: <524454F3.8000402@wwwdotorg.org>
Date: Thu, 26 Sep 2013 09:38:27 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linus.walleij@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] pinctrl: palmas: do not abort pin configuration for
 BIAS_DEFAULT
References: <1380199684-20126-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1380199684-20126-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 06:48 AM, Laxman Dewangan wrote:
> Recent movement of all configurations of pin in the single call of
> pin_config_set(), it is aborting configuration if BIAS_PULL_PIN_DEFAULT
> is selected as return of configuration.
> 
> The original idea was to just avoid any update on register for pull up/down
> configuration if this option is selected.

That doesn't sound correct. If a config option is specified in DT or the
mapping table, it should be applied to HW. If someone doesn't want a
particular config option applied, then it simply shouldn't be mentioned
in DT or the mapping table.

IIUC, BIAS_DEFAULT should be used only on HW where there is a concept of
a true default bias, and in that case, that is what should be applied.

