Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab3CYHCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 03:02:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64520 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab3CYHCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 03:02:37 -0400
X-IronPort-AV: E=Sophos;i="4.87,343,1363104000"; 
   d="scan'208";a="6938322"
Message-ID: <514FF70A.6080402@cn.fujitsu.com>
Date: Mon, 25 Mar 2013 15:04:42 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lenky Gao <lenky.gao@gmail.com>
CC: linux-kernel@vger.kernel.org, yinghai@kernel.org, mingo@elte.hu,
        gorcunov@gmail.com, rusty@rustcorp.com.au, sivanich@sgi.com,
        agordeev@redhat.com
Subject: Re: Question: How to distribute the interrupts over multiple cores?
References: <CAAO_Xo6=2PKumrxjb1XthsiVVFJcz33o5wf2OyXN9pPdu1GCRA@mail.gmail.com> <514FBD6E.2030706@cn.fujitsu.com> <CAAO_Xo7edAuiGQaXHuyWB5RPgPd5dDDRof3-d28eu+mryJkv+Q@mail.gmail.com> <514FC385.4030008@cn.fujitsu.com> <CAAO_Xo7FbEsG=6pmcfUDyKtcPuPLTkNY+kUU+5hFnzciQBO-Aw@mail.gmail.com> <514FDE5F.5020500@cn.fujitsu.com> <CAAO_Xo6dG8C_-e4mHuKm12vQ7MVoYR8fPggK00T28i0JzqpDyA@mail.gmail.com>
In-Reply-To: <CAAO_Xo6dG8C_-e4mHuKm12vQ7MVoYR8fPggK00T28i0JzqpDyA@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/25 15:01:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/25 15:01:49,
	Serialize complete at 2013/03/25 15:01:49
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/25/2013 02:46 PM, Lenky Gao wrote:
>> Do you mean on your old machine the irq will be distributed automatically
>> among the cpus set by smp_affinity?
>>
> 
> Yes. My another machine's interrupts are as follows:
And without irqbalance service? It sounds weird to me..

thanks,
linfeng

> 
> [root@localhost ~]# cat /proc/cpuinfo
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 6
> model		: 23
> model name	: Pentium(R) Dual-Core  CPU      E6700  @ 3.20GHz
> ...
> [root@localhost ~]# echo 3 > /proc/irq/18/smp_affinity
> [root@localhost ~]# cat /proc/irq/18/smp_affinity
> 3
> [root@localhost ~]# cat /proc/interrupts | grep eth2
>   18:        455       458   IO-APIC-fasteoi   eth2
> [root@localhost ~]# cat /proc/interrupts | grep eth2
>   18:        463       467   IO-APIC-fasteoi   eth2
> [root@localhost ~]# cat /proc/interrupts | grep eth2
>   18:        471       476   IO-APIC-fasteoi   eth2
> 
> 
