Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbaBNFQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 00:16:43 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:14233 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaBNFQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 00:16:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 13 Feb 2014 21:14:00 -0800
Message-ID: <52FDA6B4.6070404@nvidia.com>
Date: Fri, 14 Feb 2014 14:16:36 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
CC: Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [PATCH v2 4/6] ARM: firmware: add prepare_idle() operation
References: <1391747706-1847-1-git-send-email-acourbot@nvidia.com> <1391747706-1847-5-git-send-email-acourbot@nvidia.com> <52FCA5FC.80504@samsung.com>
In-Reply-To: <52FCA5FC.80504@samsung.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2014 08:01 PM, Tomasz Figa wrote:
> Hi Alexandre,
>
> On 07.02.2014 05:35, Alexandre Courbot wrote:
>> Some firmwares do not put the CPU into idle mode themselves, but still
>> need to be informed that the CPU is about to enter idle mode before this
>> happens. Add a prepare_idle() operation to the firmware_ops structure to
>> handle such cases.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>>    arch/arm/include/asm/firmware.h | 4 ++++
>>    1 file changed, 4 insertions(+)
>
> I wonder if .do_idle() couldn't simply return an appropriate error code
> to let the upper layer know that it should proceed with normal CPU idle
> activation, while still letting the firmware know that the CPU is going
> to idle.

In our particular case I agree it would be enough to use do_idle() to 
let the firmware know about the operation and have it return -ENOSYS so 
the kernel actually performs it. I'm afraid this might not fulfill all 
needs though (e.g. one can imagine a firmware where the OS needs to take 
action between the notification and the actual shutdown), and as Stephen 
pointed out that would make the name of the function ambiguous at best. 
I'd rather keep it the current way for clarity.
