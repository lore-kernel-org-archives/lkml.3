Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbbASDFV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 22:05:21 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:1034 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbbASDFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 22:05:20 -0500
Message-ID: <54BC742E.80006@huawei.com>
Date: Mon, 19 Jan 2015 11:04:14 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: <tixy@linaro.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <lizefan@huawei.com>
Subject: Re: [PATCH] kprobes: bugfix: checks kprobes_all_disarmed in unoptimized_kprobe().
References: <54B3B32E.7070709@hitachi.com> <1421064563-77831-1-git-send-email-wangnan0@huawei.com> <54B3C3A0.6010708@hitachi.com>
In-Reply-To: <54B3C3A0.6010708@hitachi.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.129]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.54BC743B.0087,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 5a4604bdb76a0625fff4be99928e3aa2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami Hiramatsu,

I can't find this patch and '[PATCH] kprobes: bugfix: checks kprobes_all_disarmed
in unoptimized_kprobe().' in current mainline. How do these patches get there?
Should they be merged into Russell King's tree first?

Thank you!

On 2015/1/12 20:52, Masami Hiramatsu wrote:
> (2015/01/12 21:09), Wang Nan wrote:
>> Original code failed to disarm the probed instruction after
>>
>> echo 0 > /sys/kernel/debug/kprobes/enabled
>>
>> if OPTPROBE is enabled.
>>
>> This patch checks kprobes_all_disarmed in unoptimized_kprobe().
>>
> 
> Looks good :)
> 
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> Thank you!
> 
>> Signed-off-by: Wang Nan <wangnan0@huawei.com>
>> ---
>>  kernel/kprobes.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
>> index 9471710..f16936b 100644
>> --- a/kernel/kprobes.c
>> +++ b/kernel/kprobes.c
>> @@ -630,6 +630,9 @@ static void unoptimize_kprobe(struct kprobe *p, bool force)
>>  {
>>  	struct optimized_kprobe *op;
>>  
>> +	if (kprobes_all_disarmed)
>> +		return;
>> +
>>  	if (!kprobe_aggrprobe(p) || kprobe_disarmed(p))
>>  		return; /* This is not an optprobe nor optimized */
>>  
>>
> 
> 


