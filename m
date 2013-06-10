Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab3FJPe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 11:34:29 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:65369 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab3FJPe2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 11:34:28 -0400
X-AuditID: cbfec37d-b7f036d000004805-dc-51b5f2039275
From: Shuah Khan <shuah.kh@samsung.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jingoo Han <jg1.han@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "FlorianSchandinat@gmx.de" <FlorianSchandinat@gmx.de>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "tomi.valkeinen@ti.com" <tomi.valkeinen@ti.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH] backlight: add CONFIG_PM_SLEEP to suspend/resume functions
Thread-topic: [PATCH] backlight: add CONFIG_PM_SLEEP to suspend/resume functions
Thread-index: Ac5jH8VQZVjkEXLOR6aHDdNliT5UcQ==
Date: Mon, 10 Jun 2013 15:34:25 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61566A61@sisaex02sj>
References: <000201ce631f$d4ad0d50$7e0727f0$@samsung.com>
 <2386569.59VQ9D5dv5@wuerfel>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t9hX13mT1sDDS6s57eYs34Nm8XfScfY
	LTpnXmO0uLzwEqvFib4PrBaXd81hs1j38AWTxeMVb9ktdu96ymrx9aeDxfr5t9gcuD1+/5rE
	6LFz1l12jw8f4zwW73nJ5PHqwh0WjxMzfrN47Jn/g9Wjb8sqRo/jN7YzeXzeJBfAFcVlk5Ka
	k1mWWqRvl8CV8WLhddaCL5wVm5atY2xgXMfRxcjJISFgInGkbx8ThC0mceHeerYuRi4OIYFl
	jBL96zawQji9TBLtX9azg1QJCcxnlFh2MQ7EZhNQl/j8egdYXERAUWLqi2fMIA3MAp0sEs/2
	f2AESQgL+Ev031/EBlEUIPFi8wMmCFtPYlvDcbAaFgFVic/Hp4DV8ArYS/zt+ARkcwAti5DY
	8FwLJMwIdN33U2vAWpkFxCWaW2+yQFwtILFkz3lmCFtU4uXjf6wgrRJA92xfbQVRriWxfudx
	qFZtiSfvLrBCbBKU+DH5HssERrFZSKbOQtIyC0nLLCQtCxhZVjGKlRYnFxQnpadWmOgVJ+YW
	l+al6yXn525ihER57Q7G+19tDjEKcDAq8fA+/LUlUIg1say4MvcQowQHs5IIb/KbrYFCvCmJ
	lVWpRfnxRaU5qcWHGJk4OKUaGOeZBq5565chfNz0Q712bqBTkE3Wks7ZMh6a8ybP+l+ydlW+
	TqTFx+vZ/d4Kk8Pit74oTlbdXWJ8ZRJ3948LV719mwOrvzumB6364X3nYODfkPu1t4t2GrzS
	5Nqnv5lbYlusFIffB44fMyavmS78/sGC2aEJTC+3/eGQ3M3mJ7x+No+E3k/9biWW4oxEQy3m
	ouJEAFZX5NzQAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 04:25 AM, Arnd Bergmann wrote:
> On Friday 07 June 2013 10:39:20 Jingoo Han wrote:
>> Add CONFIG_PM_SLEEP to suspend/resume functions to fix the following
>> build warning when CONFIG_PM_SLEEP is not selected. This is because
>> sleep PM callbacks defined by SIMPLE_DEV_PM_OPS are only used when
>> the CONFIG_PM_SLEEP is enabled.
>>
>> drivers/video/backlight/backlight.c:211:12: warning: 'backlight_suspend' defined but not used [-Wunused-function]
>> drivers/video/backlight/backlight.c:225:12: warning: 'backlight_resume' defined but not used [-Wunused-function]
>>
>> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
>
> I forgot:
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
>

Jingoo Han, and Arnd,

Sorry I was on vacation all of last week. Thanks for fixing the problem. 
My apologies for introducing the warnings. I had CONFIG_PM and 
CONFIG_PM_SLEEP both enabled and didn't see this warning. I will be 
careful with subsequent patches in this area.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
