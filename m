Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab3KWDXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 22:23:18 -0500
Received: from smtp2.ustc.edu.cn ([202.38.64.46]:60327 "EHLO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755577Ab3KWDXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 22:23:17 -0500
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Nov 2013 22:23:14 EST
MIME-Version: 1.0
In-Reply-To: <1385137972.10637.86.camel@edumazet-glaptop2.roam.corp.google.com>
References: <CAJULonje7V_sMt6joBBsM3uuQkYFhfNK70BXzN0EyS3sQNb0uQ@mail.gmail.com>
	<1385137972.10637.86.camel@edumazet-glaptop2.roam.corp.google.com>
Date: Sat, 23 Nov 2013 11:16:05 +0800
Message-ID: <CAJULongu0OA0wsvnzoJQwSDR1OsE5MYz3Skn7_H0ti-azSTPTg@mail.gmail.com>
Subject: Re: [Doubt on Implict BUGs caused LRO] doubt about lro status in
 v3.12 of torvalds/linux.git
From: Yanfei Wang <backyes@mail.ustc.edu.cn>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev <netdev@vger.kernel.org>,
        China Kernel <kernel@vger.linux-kernel.cn>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-CM-TRANSID: yia_0ZD7Dyb2HZBSALEIGQ--.2008S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXryrJryxCw48CFWUArWkZwb_yoW5Gryfpr
	WrGa4UKFWDJr13Ww1vvF97GFyaqw48Jr90kr13Gw4avFnFvFnYqa9FyryUKFs7Ars8Ka1F
	9aykWF1YkFnxZ3DanT9S1TB71UUUUUUv73VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjpvb7
	Iv0xC_Zr1lb4IE77IF4wAFxVCF77xC6IxKo4kEV4yl1I0EscIYIxCEI4klw4CSwwAqjxCE
	c2xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E74AGY7Cv6cx26r
	4rMcIj6xIIjxv20xvE14v26rWY6Fy7McIj6xkF7I0En7xvr7AKxVWUJVW8JwAv7VC2z280
	aVAFwI0_Cr1j6rxdMxkFs20EbsIEYx1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaV
	Av8VW8WwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JYxBIdaVFxhVjvjDU0xZF
	pf9x07jcmiiUUUUU=
X-CM-SenderInfo: 5edfy51hv6zt1loo32lwfovvfxof0/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

Thanks for quick reply.  :-)

Also, I am confused that in v3.12 why inet_lro.c file is not found in
/net/ipv4/ directory, while Makefile has "obj-$(CONFIG_INET_LRO) +=
inet_lro.o" and LRO heads file exsits.

If I am wrong, pls correct me, :-)

 See the steps 3 for details,(I have repeated it for several times)
----
3. cd net/ipv4,
 [backyes@f14 ipv4]$ cat Makefile | grep lro
obj-$(CONFIG_INET_LRO) += inet_lro.o
[backyes@f14 ipv4]$ ls inet_*
inet_connection_sock.c  inet_diag.c  inet_fragment.c
inet_hashtables.c  inet_timewait_sock.c
---

Best regards

Yanfei Wang




On Sat, Nov 23, 2013 at 12:32 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Fri, 2013-11-22 at 23:00 +0800, Yanfei Wang wrote:
>> Hi,
>>
>> Compared to the earlier kernel version, I found that Large receive
>> offload(LRO) is obsolete in latest kernel, and that is verified from
>> other materials about Generic receive offload(GRO).
>>
>> However,  I also found some LRO header files and  lro-related
>> functions referred by some drivers, and the lro-related function
>> definition is already removed at the same time!
>>
>> TEST steps:
>> 1. my git local db config as follow, url =
>> http://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>> 2. git checkout v3.12 -b 3.12
>> 3. cd net/ipv4,
>>  [backyes@f14 ipv4]$ cat Makefile | grep lro
>> obj-$(CONFIG_INET_LRO) += inet_lro.o
>> [backyes@f14 ipv4]$ ls inet_*
>> inet_connection_sock.c  inet_diag.c  inet_fragment.c
>> inet_hashtables.c  inet_timewait_sock.c
>> [backyes@f14 ipv4]$
>> Here, Makefile has inet_lro.o config, while the inet_lro.c is removed.
>> 4. lro functions referred by some drivers, as follow,
>> [backyes@f14 linux]$ grep "inet_lro" * -r
>> drivers/net/ethernet/pasemi/pasemi_mac.c:#include <linux/inet_lro.h>
>> drivers/net/ethernet/pasemi/pasemi_mac_ethtool.c:#include <linux/inet_lro.h>
>> drivers/infiniband/hw/nes/nes_hw.c:#include <linux/inet_lro.h>
>> drivers/infiniband/hw/nes/nes_hw.h:#include <linux/inet_lro.h>
>> include/linux/inet_lro.h: *  linux/include/linux/inet_lro.h
>> net/ipv4/Makefile:obj-$(CONFIG_INET_LRO) += inet_lro.o
>>
>> so, I understand that the removal of LRO is not clean, which will
>> cause compiler error for some kernel config.
>>
>
> I think you are slightly confused.
>
> LRO is not yet removed.
>
> Feel free to contribute ;)
>
> As long as at least one driver still uses LRO, we can not remove LRO.
>
> Converting a driver means testing the new driver, and owning the
> hardware.
>
>
>

