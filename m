Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab3FGCZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 22:25:16 -0400
Received: from smtpbg52.qq.com ([64.71.138.43]:51384 "HELO smtpbg52.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755532Ab3FGCZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 22:25:15 -0400
X-QQ-mid: bizesmtp5t1370571908t907t046
X-QQ-SSF: 00200000000000F0FLF2000A0000000
Message-ID: <51B14472.60904@kylinos.com.cn>
Date: Fri, 07 Jun 2013 10:24:50 +0800
From: "weiqi@kylinos.com.cn" <weiqi@kylinos.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "weiqi@kylinos.com.cn" <weiqi@kylinos.com.cn>,
        torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: race condition in schedule_on_each_cpu()
References: <tencent_0777D84B54B4163A3B85255A@qq.com> <20130606212303.GH5045@htj.dyndns.org> <51B138AA.4070707@kylinos.com.cn>
In-Reply-To: <51B138AA.4070707@kylinos.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-QQ-FName: 0DA3D3AB847448B7B7A7F11D00339B94
X-QQ-LocalIP: 112.95.241.173
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the previous  message,You mentioned:


>> by the way, I'm wondering about  what's the race condition before
which  doesn't exist now


> Before the commit you originally quoted, the calling thread could be
preempted and migrated to another CPU before get_online_cpus() thus
ending up executing the function twice on the new cpu but skipping the
old one.


does this situation will happen in "Full preemption" config, on 3.0.30-rt50?







于 2013年06月07日 09:34, weiqi@kylinos.com.cn 写道:
> it's preemption mode related ,
>
> on the 3.0.30-rt50, only   config kernel  with highest preemption 
> level (Fully Preemptible Kernel (RT)) in cpu preemption model
> will cause problem
>
> and even i use the "Preemptible Kernel" or "Preemptible Kernel 
> (Low-Latency Desktop)"  the problem would not happen..
>
>
> > I looked through the logs but the only worker depletion related 
> patches which pop up are around CPU hotplugs, so I don't think they 
> apply here. If the problem is relatively easy to reproduce && you 
> can't move onto a newer kernel, I'm afraid bisection probably is the 
> best option. Thanks!
>


