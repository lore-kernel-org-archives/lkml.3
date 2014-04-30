Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbaD3B3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 21:29:18 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:55222 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaD3B3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 21:29:15 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s3U1SlMu008134, This message is accepted by code: ctloc85258
Message-ID: <536052C9.309@realsil.com.cn>
Date: Wed, 30 Apr 2014 09:32:57 +0800
From: micky <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: <chris@printf.net>, <ulf.hansson@linaro.org>, <sameo@linux.intel.com>,
        <gregkh@linuxfoundation.org>, <dan.carpenter@oracle.com>,
        <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>
Subject: Re: [PATCH 0/2] mmc: rtsx: revert support for mmc async request
References: <cover.1398735435.git.micky_ching@realsil.com.cn> <20140429080240.GC29462@lee--X1>
In-Reply-To: <20140429080240.GC29462@lee--X1>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On 04/29/2014 04:02 PM, Lee Jones wrote:
>> From: Micky Ching <micky_ching@realsil.com.cn>
>>
>> The commit <mmc: rtsx: add support for pre_req and post_req> have some problem,
>> using mutex_unlock() in atomic context, spinlock deadlock, it is hard to fix
>> these problem, and better to use a new method. So just remove it.
>>
>> The commit <mmc: rtsx: modify error handle and remove smatch warnings> depends
>> on the previous patch. And mainly fix some problem for the previous patch. So
>> need remove.
>>
>> Micky Ching (2):
>>    mmc: rtsx: Revert "mmc: rtsx: modify error handle and remove smatch
>>      warnings"
>>    mmc: rtsx: Revert "mmc: rtsx: add support for pre_req and post_req"
>>
>>   drivers/mfd/rtsx_pcr.c            |  132 ++++-------
>>   drivers/mmc/host/rtsx_pci_sdmmc.c |  459 +++++++------------------------------
>>   include/linux/mfd/rtsx_common.h   |    1 -
>>   include/linux/mfd/rtsx_pci.h      |    6 -
>>   4 files changed, 124 insertions(+), 474 deletions(-)
> Just to clarify, what commit did you base these changes on? Have you
> tested to ensure everything works as it should with these two
> reversions?
>
I base on linux-nex tree
commit d397246adc001ee5235f32de10db112ad23175df
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Thu Apr 24 16:22:09 2014 +1000

     Add linux-next specific files for 20140424

     Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

And tested, so it can works ok.

Best Regards.
micky.


