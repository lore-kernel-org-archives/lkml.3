Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab3I0NHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:07:35 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9138 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab3I0NHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:07:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 27 Sep 2013 06:03:51 -0700
Message-ID: <52458876.4070205@nvidia.com>
Date: Fri, 27 Sep 2013 19:00:30 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] pinctrl: palmas: do not abort pin configuration for
 BIAS_DEFAULT
References: <1380199684-20126-1-git-send-email-ldewangan@nvidia.com> <524454F3.8000402@wwwdotorg.org>
In-Reply-To: <524454F3.8000402@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 September 2013 09:08 PM, Stephen Warren wrote:
> On 09/26/2013 06:48 AM, Laxman Dewangan wrote:
>> Recent movement of all configurations of pin in the single call of
>> pin_config_set(), it is aborting configuration if BIAS_PULL_PIN_DEFAULT
>> is selected as return of configuration.
>>
>> The original idea was to just avoid any update on register for pull up/down
>> configuration if this option is selected.
> That doesn't sound correct. If a config option is specified in DT or the
> mapping table, it should be applied to HW. If someone doesn't want a
> particular config option applied, then it simply shouldn't be mentioned
> in DT or the mapping table.
>
> IIUC, BIAS_DEFAULT should be used only on HW where there is a concept of
> a true default bias, and in that case, that is what should be applied.
>

Hmm.. When I added the PIN_DEFAULT, I just though that do not update 
anything in the register and implemented like that.
There is nothing "default" option in HW.

In this patch, I just fixed the broken stuff due to recent change.

However, it the PIN_DEFAULT is not valid option then I need to remove it 
from driver as well as from dt document of Palmas.

