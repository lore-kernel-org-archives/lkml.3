Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab3DUS4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 14:56:44 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:49694 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab3DUS4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 14:56:43 -0400
Message-ID: <51743666.2070006@gmail.com>
Date: Sun, 21 Apr 2013 20:56:38 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] of: export of_get_next_parent
References: <1365587227-26137-1-git-send-email-ming.lei@canonical.com> <CACVXFVMuUn=0LLWxJO62gp6uugNej-kwC0k_LMGWozGRxcx6Vg@mail.gmail.com>
In-Reply-To: <CACVXFVMuUn=0LLWxJO62gp6uugNej-kwC0k_LMGWozGRxcx6Vg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/21/2013 02:11 PM, Ming Lei wrote:
> On Wed, Apr 10, 2013 at 5:47 PM, Ming Lei<ming.lei@canonical.com>  wrote:
>> The function is called by at least three drivers now:
>>
>>          pinctrl
>>          mfd/vexpress
>>          v4l2-core
>>
>> The 3rd one can be built as module, so export the function to
>> avoid build failure.
>>
>> Cc: Grant Likely<grant.likely@secretlab.ca>
>> Cc: Rob Herring<rob.herring@calxeda.com>
>> Cc: devicetree-discuss@lists.ozlabs.org
>> Signed-off-by: Ming Lei<ming.lei@canonical.com>
>> ---
>>   drivers/of/base.c |    1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/of/base.c b/drivers/of/base.c
>> index c6443de..a2a0ddc 100644
>> --- a/drivers/of/base.c
>> +++ b/drivers/of/base.c
>> @@ -382,6 +382,7 @@ struct device_node *of_get_next_parent(struct device_node *node)
>>          raw_spin_unlock_irqrestore(&devtree_lock, flags);
>>          return parent;
>>   }
>> +EXPORT_SYMBOL(of_get_next_parent);
>
> Gentle ping.
>
> Without the patch, the below build failure is produced every time on -next tree:

A similar patch has been queued in the media tree [1]. It should soon 
appear in -next.

[1] 
http://git.linuxtv.org/mchehab/media-next.git/commitdiff/6695be6863b75620ffa6d422965680ce785cb7c8

Sorry for the trouble.

Thanks,
Sylwester
