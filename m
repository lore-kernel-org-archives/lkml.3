Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab3CYGxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 02:53:36 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:55940 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab3CYGxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 02:53:35 -0400
MIME-Version: 1.0
In-Reply-To: <514FDE5F.5020500@cn.fujitsu.com>
References: <CAAO_Xo6=2PKumrxjb1XthsiVVFJcz33o5wf2OyXN9pPdu1GCRA@mail.gmail.com>
	<514FBD6E.2030706@cn.fujitsu.com>
	<CAAO_Xo7edAuiGQaXHuyWB5RPgPd5dDDRof3-d28eu+mryJkv+Q@mail.gmail.com>
	<514FC385.4030008@cn.fujitsu.com>
	<CAAO_Xo7FbEsG=6pmcfUDyKtcPuPLTkNY+kUU+5hFnzciQBO-Aw@mail.gmail.com>
	<514FDE5F.5020500@cn.fujitsu.com>
Date: Mon, 25 Mar 2013 14:46:03 +0800
Message-ID: <CAAO_Xo6dG8C_-e4mHuKm12vQ7MVoYR8fPggK00T28i0JzqpDyA@mail.gmail.com>
Subject: Re: Question: How to distribute the interrupts over multiple cores?
From: Lenky Gao <lenky.gao@gmail.com>
To: Lin Feng <linfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, yinghai@kernel.org, mingo@elte.hu,
        gorcunov@gmail.com, rusty@rustcorp.com.au, sivanich@sgi.com,
        agordeev@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do you mean on your old machine the irq will be distributed automatically
> among the cpus set by smp_affinity?
>

Yes. My another machine's interrupts are as follows:

[root@localhost ~]# cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Pentium(R) Dual-Core  CPU      E6700  @ 3.20GHz
...
[root@localhost ~]# echo 3 > /proc/irq/18/smp_affinity
[root@localhost ~]# cat /proc/irq/18/smp_affinity
3
[root@localhost ~]# cat /proc/interrupts | grep eth2
  18:        455       458   IO-APIC-fasteoi   eth2
[root@localhost ~]# cat /proc/interrupts | grep eth2
  18:        463       467   IO-APIC-fasteoi   eth2
[root@localhost ~]# cat /proc/interrupts | grep eth2
  18:        471       476   IO-APIC-fasteoi   eth2


-- 
Regards,

Lenky
