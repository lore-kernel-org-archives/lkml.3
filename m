Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab3GBTtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 15:49:13 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:62296 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754646Ab3GBTtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 15:49:11 -0400
Message-ID: <51D32F7F.4090606@metafoo.de>
Date: Tue, 02 Jul 2013 21:52:31 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Shuah Khan <shuah.kh@samsung.com>
CC: Hauke Mehrtens <hauke@hauke-m.de>, "bzhao@marvell.com" <bzhao@marvell.com>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH] wireless: Convert mwifiex/pcie to dev_pm_ops from legacy
 pm ops
References: <1372778675-2909-1-git-send-email-shuah.kh@samsung.com> <51D32116.4010109@hauke-m.de> <B8EFE96D1287C24090BAD9D858E15E61734462@sisaex02sj>
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E61734462@sisaex02sj>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2013 09:24 PM, Shuah Khan wrote:
[...]
>>> +#ifdef CONFIG_PM
>>> +/* Power Management Hooks */
>>> +static const struct dev_pm_ops mwifiex_pcie_pm_ops = {
>>> +	.suspend = mwifiex_pcie_suspend,
>>> +	.resume = mwifiex_pcie_resume,
>>> +};
>>> +#endif
>>> +
>>
>> Is it intended that you do not use SIMPLE_DEV_PM_OPS() like most of the
>> other wifi drivers?
> 
> So the reason for this is SIMPLE_DEV_PM_OPS() is defined only when 
> CONFIG_PM_SLEEP is enabled. This driver doesn't defines suspend and 
> resume when CONFIG_PM is enabled and I didn't want to change that. Hope 
> that helps understand why I didn't use SIMPLE_DEV_PM_OPS()

Change the ifdefs to CONFIG_PM_SLEEP and use SIMPLE_DEV_PM_OPS. The driver does
not support runtime PM.

- Lars

