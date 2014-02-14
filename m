Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaBNKm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 05:42:57 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:43218 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaBNKmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:42:55 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-cd-52fdf32d2dcf
Message-id: <52FDF32A.1040809@samsung.com>
Date: Fri, 14 Feb 2014 11:42:50 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [PATCH v2 4/6] ARM: firmware: add prepare_idle() operation
References: <1391747706-1847-1-git-send-email-acourbot@nvidia.com>
 <1391747706-1847-5-git-send-email-acourbot@nvidia.com>
 <52FCA5FC.80504@samsung.com> <52FDA6B4.6070404@nvidia.com>
In-reply-to: <52FDA6B4.6070404@nvidia.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t/xa7q6n/8GGTR3qll8f3iK1eLcq0cs
	FpseX2O1uLxrDptF55dZbBa3L/NanLr+mc3i1cE2Foufu+axOHB6tDT3sHnsnHWX3WPzknqP
	KyeaWD16m9+xeXzeJOexcW5oAHsUl01Kak5mWWqRvl0CV8aDz/uZCjZxV0x91czcwNjP2cXI
	ySEhYCKxsWc7K4QtJnHh3nq2LkYuDiGBpYwS3U/vM0M4nxklmia2ADkcHLwCWhL7vpqANLAI
	qEo83bGBCcRmE1CT+NzwiA3EFhWIkPg7bz0jiM0rICjxY/I9FhBbRGA1o8Tn92EgM5kF5jJJ
	TPnfAtYgLOAusbDnL1iDkMAORomLm41BdnEC7Vrf4wgSZhawllg5aRsjhC0vsXnNW+YJjAKz
	kKyYhaRsFpKyBYzMqxhFU0uTC4qT0nON9IoTc4tL89L1kvNzNzFC4uDrDsalx6wOMQpwMCrx
	8H64+ydIiDWxrLgy9xCjBAezkgiv+/6/QUK8KYmVValF+fFFpTmpxYcYmTg4pRoYva2kfsZk
	TF1yvOhU+eWp7u/6v309xr3oZbDwtFOsBgmZLAZrLaS/rVZ4fZTHSJejvi2IqzLQ8rO44KeL
	m1knzxD9Jq3zXp/9vPYGw+sa00Jqd734sOTNw4zXbxft/vbn0uYZt2coP1xxWLCXa/fGp4v/
	9/KcuHheVCSeW24D24a6fvPLoT8nZCqxFGckGmoxFxUnAgCJL7ykYQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.02.2014 06:16, Alexandre Courbot wrote:
> On 02/13/2014 08:01 PM, Tomasz Figa wrote:
>> Hi Alexandre,
>>
>> On 07.02.2014 05:35, Alexandre Courbot wrote:
>>> Some firmwares do not put the CPU into idle mode themselves, but still
>>> need to be informed that the CPU is about to enter idle mode before this
>>> happens. Add a prepare_idle() operation to the firmware_ops structure to
>>> handle such cases.
>>>
>>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>>> ---
>>>    arch/arm/include/asm/firmware.h | 4 ++++
>>>    1 file changed, 4 insertions(+)
>>
>> I wonder if .do_idle() couldn't simply return an appropriate error code
>> to let the upper layer know that it should proceed with normal CPU idle
>> activation, while still letting the firmware know that the CPU is going
>> to idle.
>
> In our particular case I agree it would be enough to use do_idle() to
> let the firmware know about the operation and have it return -ENOSYS so
> the kernel actually performs it. I'm afraid this might not fulfill all
> needs though (e.g. one can imagine a firmware where the OS needs to take
> action between the notification and the actual shutdown), and as Stephen
> pointed out that would make the name of the function ambiguous at best.
> I'd rather keep it the current way for clarity.
>

OK. I'm not strongly against this, just wanted some more thought on 
this, so please move on.

Best regards,
Tomasz
