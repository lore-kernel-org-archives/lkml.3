Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab3GBW7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 18:59:06 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:37464 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab3GBW7E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 18:59:04 -0400
X-AuditID: cbfec37a-b7fc36d0000050de-40-51d35b3561a0
From: Shuah Khan <shuah.kh@samsung.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, "bzhao@marvell.com" <bzhao@marvell.com>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH] wireless: Convert mwifiex/pcie to dev_pm_ops from legacy
 pm ops
Thread-topic: [PATCH] wireless: Convert mwifiex/pcie to dev_pm_ops from legacy
 pm ops
Thread-index: AQHOdziXnP98K4VpIEGkm+ryIjYhOw==
Date: Tue, 02 Jul 2013 22:59:00 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6173482E@sisaex02sj>
References: <1372778675-2909-1-git-send-email-shuah.kh@samsung.com>
 <51D32116.4010109@hauke-m.de>
 <B8EFE96D1287C24090BAD9D858E15E61734462@sisaex02sj>
 <51D32F7F.4090606@metafoo.de>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsVy+t9hX13T6MuBBsff2FjM23qU1eLKy1CL
	JZPns1pc3jWHzeLNijvsFlt7JCyOLRCz6F/Yy2Tx9aeDA6fHzll32T3uP93H7DF54UVmjyVv
	DrF6PFrcwuhx5ftqRo/Pm+QC2KO4bFJSczLLUov07RK4MppePmMqOMdZ0XJ7MlsD40/2LkZO
	DgkBE4kNrX/YIGwxiQv31gPZXBxCAssYJaZc+8YK4fQySaw79ZURwpnPKPHkQDdYO5uAusTn
	1zvAbBEBDYn/byaB2cwC65klDu6tBrGFBcIk2r/+YYaoCZc4/WsVC4StJ7HtWSdYnEVAVWLP
	umOMIDavgL3E0yUboJbtZJRYfGA6WAMj0H3fT61hglggLtHcepMF4m4BiSV7zjND2KISLx//
	AzqbA8hWlNi+2gqiXEti/c7jUK3aEk/eXWCF2CUo8WPyPZYJjGKzkEydhaRlFpKWWUhaFjCy
	rGIUKy1OLihOSk+tMNQrTswtLs1L10vOz93ECInZqh2Md77aHGIU4GBU4uF1eHYpUIg1say4
	MvcQowQHs5IIL7fw5UAh3pTEyqrUovz4otKc1OJDjEwcnFINjPN3n3GK33brsKNHuP3h2M11
	z8oeBnV8iJv+e7On4+pT57a9N8w7cKA3Y86ZSXdOuUswxsx7uMDtgv19lboTLSuc/++Tfahu
	8cGsXPn71f1873wm+h+W/7bt2df/Cvo/7saHVVg2sxgdLXNSjbZaselZBsO6r1q2PZFa+gqu
	ek8rdP6YRf9b+1GJpTgj0VCLuag4EQBwaiz5twIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2013 01:49 PM, Lars-Peter Clausen wrote:
> On 07/02/2013 09:24 PM, Shuah Khan wrote:
> [...]
>>>> +#ifdef CONFIG_PM
>>>> +/* Power Management Hooks */
>>>> +static const struct dev_pm_ops mwifiex_pcie_pm_ops = {
>>>> +	.suspend = mwifiex_pcie_suspend,
>>>> +	.resume = mwifiex_pcie_resume,
>>>> +};
>>>> +#endif
>>>> +
>>>
>>> Is it intended that you do not use SIMPLE_DEV_PM_OPS() like most of the
>>> other wifi drivers?
>>
>> So the reason for this is SIMPLE_DEV_PM_OPS() is defined only when
>> CONFIG_PM_SLEEP is enabled. This driver doesn't defines suspend and
>> resume when CONFIG_PM is enabled and I didn't want to change that. Hope
>> that helps understand why I didn't use SIMPLE_DEV_PM_OPS()
>
> Change the ifdefs to CONFIG_PM_SLEEP and use SIMPLE_DEV_PM_OPS. The driver does
> not support runtime PM.
>
> - Lars
>
>


Thanks. I will update the patch to use SIMPLE_DEV_PM_OPS.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
