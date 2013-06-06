Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab3FFVXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:23:09 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:59456 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab3FFVXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:23:06 -0400
Date: Thu, 6 Jun 2013 14:23:03 -0700
From: Tejun Heo <tj@kernel.org>
To: =?utf-8?B?6Z+m5aWH?= <weiqi@kylinos.com.cn>
Cc: torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: race condition in schedule_on_each_cpu()
Message-ID: <20130606212303.GH5045@htj.dyndns.org>
References: <tencent_0777D84B54B4163A3B85255A@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tencent_0777D84B54B4163A3B85255A@qq.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jun 06, 2013 at 06:14:46PM +0800, 韦奇 wrote:
> Hello, Tejun Heo
> thanks for your help,
> 1) I've test the two kernel version on this problem:
>     latest 3.10-rc3：(https://www.kernel.org/pub/linux/kernel/v3.x/testing/linux-3.10-rc3.tar.xz)
>      latest 3.0branch - 3.0.80：(https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.0.80.tar.xz
> 
> they all work fine when hot remove raid disk..

Thanks for verifying.

> | preemption                  | machine 1      | machine 2      | kversion    |
> -------------------------------------------------------------------------------
> | Fully Preemptible           |      stuck     |      no stuck  | 3.0.30-rt50 |
> | Low-Latency Desktop         |      no stuck  |      no stuck  | 3.0.30-rt50 |
> | Low-Latency Desktop         |      no stuck  |      --        | 3.0.30      |
> | default                     |      no stuck  |      --        | 3.0.80      |
> | default                     |      no stuck  |      --        | 3.10-rc3    |
> 
> could you tell me some way to debug this problem. for example, how
> to debug workqueue deadlock? I want to find the deadlock point.

I looked through the logs but the only worker depletion related
patches which pop up are around CPU hotplugs, so I don't think they
apply here.  If the problem is relatively easy to reproduce && you
can't move onto a newer kernel, I'm afraid bisection probably is the
best option.

Thanks!

-- 
tejun
