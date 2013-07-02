Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab3GBTY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 15:24:29 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:56227 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab3GBTY2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 15:24:28 -0400
X-AuditID: cbfec37d-b7f036d000004805-c7-51d328ea9f1a
From: Shuah Khan <shuah.kh@samsung.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: "bzhao@marvell.com" <bzhao@marvell.com>,
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
Date: Tue, 02 Jul 2013 19:24:25 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61734462@sisaex02sj>
References: <1372778675-2909-1-git-send-email-shuah.kh@samsung.com>
 <51D32116.4010109@hauke-m.de>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsVy+t9hP91XGpcDDe6/MreYt/Uoq8WVl6EW
	l3fNYbN4s+IOu8XWHgmLYwvELPoX9jJZfP3p4MDhsXPWXXaP+0/3MXtMXniR2ePR4hZGjyvf
	VzN6fN4kF8AWxWWTkpqTWZZapG+XwJXx4dFkloIfmhX9056zNTDuUOpi5OSQEDCRWNC/gw3C
	FpO4cG89mC0ksIxR4uq8Qgi7l0li0+mALkYuIHs+o8SEE3vAitgE1CU+v97BDmKLCKhK7Jxz
	gh2kiFmgh1li871FrCAJYYEwifavf5ghisIlTv9axQJh60lse9YJFmcBat449zxYPa+AvcTG
	599YIDYnSzw7Oxsszgh03fdTa5hAbGYBcYnm1pssEFcLSCzZc54ZwhaVePn4H1A9B5CtKLF9
	tRVEuZbE+p3HoVq1JZ68uwC1SlDix+R7LBMYxWYhmToLScssJC2zkLQsYGRZxShWWpxcUJyU
	nlpholecmFtcmpeul5yfu4kREpu1Oxjvf7U5xCjAwajEw+vw7FKgEGtiWXFl7iFGCQ5mJRFe
	buHLgUK8KYmVValF+fFFpTmpxYcYmTg4pRoY41YZubNlnHz5q6vN7/WXzC8sM/7PjciSmlDD
	U/pA8aaX9ee3Tg8lF5vs6Zq4XmtSdO/8z/+/fDeQkN0Rfk/96LsCsejOz3OnbtQqMbgRnbnA
	X/bh3TPbN9/iulwkwv7sjem5V/1tdlonzzyyfBcSF+lhn//2784158NeyjXv6lrKvv9NCldh
	jBJLcUaioRZzUXEiAKbT5r+rAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2013 12:51 PM, Hauke Mehrtens wrote:
> On 07/02/2013 05:24 PM, Shuah Khan wrote:
>> Convert the mwifiex/pci driver to use dev_pm_ops for power management and
>> remove Legacy PM handling. This change re-uses existing suspend and resume
>> interfaces for dev_pm_ops.
>>
>> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
>> ---
>>   drivers/net/wireless/mwifiex/pcie.c |   34 ++++++++++++++++++++++++++++------
>>   1 file changed, 28 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
>> index 20c9c4c..b169318 100644
>> --- a/drivers/net/wireless/mwifiex/pcie.c
>> +++ b/drivers/net/wireless/mwifiex/pcie.c
>> @@ -85,7 +85,7 @@ static bool mwifiex_pcie_ok_to_access_hw(struct mwifiex_adapter *adapter)
>>    * If already not suspended, this function allocates and sends a host
>>    * sleep activate request to the firmware and turns off the traffic.
>>    */
>> -static int mwifiex_pcie_suspend(struct pci_dev *pdev, pm_message_t state)
>> +static int __mwifiex_pcie_suspend(struct pci_dev *pdev)
>>   {
>>   	struct mwifiex_adapter *adapter;
>>   	struct pcie_service_card *card;
>> @@ -112,6 +112,13 @@ static int mwifiex_pcie_suspend(struct pci_dev *pdev, pm_message_t state)
>>   	return 0;
>>   }
>>
>> +static int mwifiex_pcie_suspend(struct device *dev)
>> +{
>> +	struct pci_dev *pdev = to_pci_dev(dev);
>> +
>> +	return __mwifiex_pcie_suspend(pdev);
>> +}
>> +
>
> For what do you need __mwifiex_pcie_suspend() ? Why not make one
> function out of these two?

Originally, the reason is to keep __mwifiex_pcie_suspend() and 
__mwifiex_pcie_resume() parameters the same so there will be no 
confusion. However, I didn't think about using 
mwifiex_pcie_resume(&pdev->dev) as you mentioned below. Yes, I can make 
the change and not add two additional routines and send a v2 patch.

>
>>   /*
>>    * Kernel needs to suspend all functions separately. Therefore all
>>    * registered functions must have drivers with suspend and resume
>> @@ -120,7 +127,7 @@ static int mwifiex_pcie_suspend(struct pci_dev *pdev, pm_message_t state)
>>    * If already not resumed, this function turns on the traffic and
>>    * sends a host sleep cancel request to the firmware.
>>    */
>> -static int mwifiex_pcie_resume(struct pci_dev *pdev)
>> +static int __mwifiex_pcie_resume(struct pci_dev *pdev)
>>   {
>>   	struct mwifiex_adapter *adapter;
>>   	struct pcie_service_card *card;
>> @@ -150,6 +157,13 @@ static int mwifiex_pcie_resume(struct pci_dev *pdev)
>>
>>   	return 0;
>>   }
>> +
>> +static int mwifiex_pcie_resume(struct device *dev)
>> +{
>> +	struct pci_dev *pdev = to_pci_dev(dev);
>> +
>> +	return __mwifiex_pcie_resume(pdev);
>> +}
>>   #endif
>>
>>   /*
>> @@ -213,7 +227,7 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
>>   	if (user_rmmod) {
>>   #ifdef CONFIG_PM
>>   		if (adapter->is_suspended)
>> -			mwifiex_pcie_resume(pdev);
>> +			__mwifiex_pcie_resume(pdev);
>
> You could use mwifiex_pcie_resume(&pdev->dev) here and then the extra
> function __mwifiex_pcie_resume() is not needed any more.

Yes. That would eliminate the need for additional routine. I didn't 
think about that option.

>
>>   #endif
>>
>>   		for (i = 0; i < adapter->priv_num; i++)
>> @@ -249,6 +263,14 @@ static DEFINE_PCI_DEVICE_TABLE(mwifiex_ids) = {
>>
>>   MODULE_DEVICE_TABLE(pci, mwifiex_ids);
>>
>> +#ifdef CONFIG_PM
>> +/* Power Management Hooks */
>> +static const struct dev_pm_ops mwifiex_pcie_pm_ops = {
>> +	.suspend = mwifiex_pcie_suspend,
>> +	.resume = mwifiex_pcie_resume,
>> +};
>> +#endif
>> +
>
> Is it intended that you do not use SIMPLE_DEV_PM_OPS() like most of the
> other wifi drivers?

So the reason for this is SIMPLE_DEV_PM_OPS() is defined only when 
CONFIG_PM_SLEEP is enabled. This driver doesn't defines suspend and 
resume when CONFIG_PM is enabled and I didn't want to change that. Hope 
that helps understand why I didn't use SIMPLE_DEV_PM_OPS()

>
>>   /* PCI Device Driver */
>>   static struct pci_driver __refdata mwifiex_pcie = {
>>   	.name     = "mwifiex_pcie",
>> @@ -256,9 +278,9 @@ static struct pci_driver __refdata mwifiex_pcie = {
>>   	.probe    = mwifiex_pcie_probe,
>>   	.remove   = mwifiex_pcie_remove,
>>   #ifdef CONFIG_PM
>> -	/* Power Management Hooks */
>> -	.suspend  = mwifiex_pcie_suspend,
>> -	.resume   = mwifiex_pcie_resume,
>> +	.driver   = {
>> +		.pm = &mwifiex_pcie_pm_ops,
>> +	},
>>   #endif
>>   };
>>
>>
>
>

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
