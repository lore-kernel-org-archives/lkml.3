Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab3FGBe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 21:34:56 -0400
Received: from smtpbg64.qq.com ([103.7.28.238]:49985 "HELO smtpbg64.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754574Ab3FGBez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 21:34:55 -0400
X-QQ-mid: bizesmtp3t1370568891t073t317
X-QQ-SSF: 01200000000000F0FLF2000A0000000
Message-ID: <51B138AA.4070707@kylinos.com.cn>
Date: Fri, 07 Jun 2013 09:34:34 +0800
From: "weiqi@kylinos.com.cn" <weiqi@kylinos.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: =?UTF-8?B?6Z+m5aWH?= <weiqi@kylinos.com.cn>,
        torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: race condition in schedule_on_each_cpu()
References: <tencent_0777D84B54B4163A3B85255A@qq.com> <20130606212303.GH5045@htj.dyndns.org>
In-Reply-To: <20130606212303.GH5045@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it's preemption mode related ,

on the 3.0.30-rt50, only   config kernel  with highest preemption level 
(Fully Preemptible Kernel (RT)) in cpu preemption model
will cause problem

and even i use the "Preemptible Kernel" or "Preemptible Kernel 
(Low-Latency Desktop)"  the problem would not happen..


 > I looked through the logs but the only worker depletion related 
patches which pop up are around CPU hotplugs, so I don't think they 
apply here. If the problem is relatively easy to reproduce && you can't 
move onto a newer kernel, I'm afraid bisection probably is the best 
option. Thanks!
