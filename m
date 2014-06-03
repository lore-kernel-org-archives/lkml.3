Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaFCBTD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 21:19:03 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:20214 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaFCBTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 21:19:01 -0400
Message-ID: <538D2261.70406@huawei.com>
Date: Tue, 3 Jun 2014 09:18:25 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jianyu Zhan <nasa4836@gmail.com>
Subject: Re: 3.15 regression: wrong cgroup magic
References: <CALCETrXbpiqwY=qyPcNWn2zX=vehXzBbxDG725egM9T2Ox2KTA@mail.gmail.com>
In-Reply-To: <CALCETrXbpiqwY=qyPcNWn2zX=vehXzBbxDG725egM9T2Ox2KTA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Greg
Cc: Jianyu Zhan

On 2014/6/3 8:56, Andy Lutomirski wrote:
> Sorry I didn't notice this earlier.  Linux 3.15 breaks my production

But 3.15 hasn't been released. :)

> system :(  The cause appears to be:
> 
> commit 2bd59d48ebfb3df41ee56938946ca0dd30887312
> Author: Tejun Heo <tj@kernel.org>
> Date:   Tue Feb 11 11:52:49 2014 -0500
> 
>     cgroup: convert to kernfs
> 
> In particular, this piece:
> 
> -       sb->s_magic = CGROUP_SUPER_MAGIC;
> 
> The result is that cgroup shows up with the wrong magic number, so my
> code goes "oh crap, cgroupfs isn't mounted" and fails.
> 
> I can change my code to hack around this, but I can imagine other
> things getting tripped up.  Is there still time to fix this?
> 

This should be fixed by "kernfs: move the last knowledge of sysfs out from kernfs".

It's in driver-core-next.

https://git.kernel.org/cgit/linux/kernel/git/gregkh/driver-core.git/commit/?h=driver-core-next&id=26fc9cd200ec839e0b3095e05ae018f27314e7aa

