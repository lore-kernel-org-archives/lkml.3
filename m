Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab3E0G6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 02:58:04 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:7150 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756547Ab3E0G6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 02:58:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 26 May 2013 23:57:57 -0700
Message-ID: <51A3039E.5090808@nvidia.com>
Date: Mon, 27 May 2013 09:56:30 +0300
From: Arto Merilainen <amerilainen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: "airlied@linux.ie" <airlied@linux.ie>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] gpu: host1x: Fix memory access in syncpt request
References: <1368791388-31441-1-git-send-email-amerilainen@nvidia.com> <1368791388-31441-4-git-send-email-amerilainen@nvidia.com> <20130526101551.GC1652@mithrandir>
In-Reply-To: <20130526101551.GC1652@mithrandir>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2013 01:15 PM, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Fri, May 17, 2013 at 02:49:45PM +0300, Arto Merilainen wrote:
>> This patch fixes a bad memory access in syncpoint request code. If
>> no syncpoints were available, the code accessed unreserved memory
>> area causing unexpected behaviour.
>>
>> Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
>> ---
>>   drivers/gpu/host1x/syncpt.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
>> index 5bf5366..6b7ee88 100644
>> --- a/drivers/gpu/host1x/syncpt.c
>> +++ b/drivers/gpu/host1x/syncpt.c
>> @@ -40,7 +40,7 @@ static struct host1x_syncpt *_host1x_syncpt_alloc(struct host1x *host,
>>
>>   	for (i = 0; i < host->info->nb_pts && sp->name; i++, sp++)
>>   		;
>> -	if (sp->dev)
>> +	if (i >= host->info->nb_pts)
>>   		return NULL;
>
> While changing this, can you please add a blank line between the loop
> and the new 'if (...)'?
>

Yep. Will do.

- Arto
