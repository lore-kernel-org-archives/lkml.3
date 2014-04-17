Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaDQHsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 03:48:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbaDQHsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 03:48:17 -0400
Message-ID: <534F8733.1080009@redhat.com>
Date: Thu, 17 Apr 2014 09:48:03 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        guohanjun@huawei.com, Kefeng Wang <kefeng.wang@linaro.org>
Subject: Re: [PATCH V2 2/2] ahci: add support for Hisilicon sata
References: <1397107468-640-1-git-send-email-wangkefeng.wang@huawei.com> <1397107468-640-3-git-send-email-wangkefeng.wang@huawei.com> <20140416204917.GB26632@htj.dyndns.org>
In-Reply-To: <20140416204917.GB26632@htj.dyndns.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/16/2014 10:49 PM, Tejun Heo wrote:
> Hello,
> 
> On Thu, Apr 10, 2014 at 01:24:28PM +0800, Kefeng Wang wrote:
>> From: Kefeng Wang <kefeng.wang@linaro.org>
>>
>> The hip04 SoC of hisilicon has an AHCI compliant SATA controller,
>> and it is compliant with the ahci 1.3 and sata 3.0 specification.
>>
>> There is a wrong bit in HOST_CAP of hip04 sata controller, which
>> enable unsupported feature of FBS, use AHCI_HFLAG_NO_FBS hflag to
>> disable it.
>>
>> Cc: Hans de Geode <hdegoede@redhat.com>
>> Signed-off-by: Kefeng Wang <kefeng.wang@linaro.org>
>> @@ -54,8 +55,10 @@ static int ahci_probe(struct platform_device *pdev)
>>  		if (rc)
>>  			goto disable_resources;
>>  	}
>> +	if (of_device_is_compatible(pdev->dev.of_node, "hisilicon,hisi-ahci"))
>> +		pi.private_data = (void *)AHCI_HFLAG_NO_FBS;
> 
> Hmmm.... this should work but looks a bit tedious and it could be
> better to have a better mechanism to match devices to their
> port_infos.  Hans, can you please comment?  If getting something more
> structured is too much work, I can go with this but wanna find out
> whether that's the case.

The more structured solution would be v1 of this patch, which I asked
Kefan to change since it seemed overkill. But if you prefer that version
that is fine with me.

Note that as I've already mentioned earlier in the thread this could be
made somewhat cleaner by having an host_flags parameter to
ahci_platform_init_host().

Regards,

Hans
