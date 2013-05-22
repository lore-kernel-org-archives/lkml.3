Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab3EVHAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 03:00:53 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:36401 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab3EVHAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 03:00:50 -0400
Message-ID: <519C6CF3.1010502@huawei.com>
Date: Wed, 22 May 2013 15:00:03 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] ktap 0.1 released
References: <519AF05E.1050808@huawei.com> <CACVXFVMG73_OCJOJGWR0CCeoR3taXnj+PXXah0q7fyB=Y4vfwQ@mail.gmail.com> <CACVXFVOuz-RjoQLD5mb1c5vbaNZ-H9cY7T5p1ZVLWwftwbCBcQ@mail.gmail.com> <CACVXFVPgLiFPSyLi48fa=RbyOantEu-jRynuuZFJ_4Lt5OSXYQ@mail.gmail.com>
In-Reply-To: <CACVXFVPgLiFPSyLi48fa=RbyOantEu-jRynuuZFJ_4Lt5OSXYQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/22 12:34, Ming Lei wrote:
> On Wed, May 22, 2013 at 12:19 PM, Ming Lei <tom.leiming@gmail.com> wrote:
>> On Wed, May 22, 2013 at 12:15 PM, Ming Lei <tom.leiming@gmail.com> wrote:
>>> On Tue, May 21, 2013 at 11:56 AM, zhangwei(Jovi)
>>>
>>> Nice job, I have run it on ARM already with only one line change.
>>>
>>> But looks 'Control-C' can't stop the tracing or need some time to complete it,
>>> see below:
>>
>> Sometimes, it doesn't work:
>>
>> $ sudo ./ktap ./scripts/kretprobe.kp
>> ......
>> vfs_read! (execname sshd); retval:38
>> ^Cvfs_read! (execname sshd); retval:38
>>
>> probe ending
>> vfs_read! (execname sshd); retval:48
>> vfs_read! (execname sshd); retval:2
>> ^C
>> ^C^C^C
>> ^C^C^C^C^C^C^C
>>
>> ^C^C^C^C^C^C
> 
> This one can be fixed by below patch, but can't work on
> the last one.
> 
> diff --git a/vm.c b/vm.c
> index c5f5733..a24a389 100644
> --- a/vm.c
> +++ b/vm.c
> @@ -1060,7 +1060,7 @@ ktap_State *kp_newthread(ktap_State *mainthread)
> 
>  void kp_user_complete(ktap_State *ks)
>  {
> -	if (!ks || !G(ks)->user_completion)
> +	if (!ks || !G(ks) || !G(ks)->user_completion)
>  		return;
> 
>  	complete(G(ks)->user_completion);
> 
> 
> 
> Thanks,
> 
Hi Ming,

Thanks for testing and your fix.

the ktap exit mechanism is not quite safe as you saw, so I plan to rewrite the logic
to make more safer, hopefully I could complete this work in next few days.

.jovi







