Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab3CYC4r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 22:56:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:8828 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755674Ab3CYC4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 22:56:46 -0400
X-IronPort-AV: E=Sophos;i="4.87,342,1363104000"; 
   d="scan'208";a="6935467"
Message-ID: <514FBD6E.2030706@cn.fujitsu.com>
Date: Mon, 25 Mar 2013 10:58:54 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lenky Gao <lenky.gao@gmail.com>
CC: linux-kernel@vger.kernel.org, yinghai@kernel.org, mingo@elte.hu,
        gorcunov@gmail.com, rusty@rustcorp.com.au, sivanich@sgi.com,
        agordeev@redhat.com
Subject: Re: Question: How to distribute the interrupts over multiple cores?
References: <CAAO_Xo6=2PKumrxjb1XthsiVVFJcz33o5wf2OyXN9pPdu1GCRA@mail.gmail.com>
In-Reply-To: <CAAO_Xo6=2PKumrxjb1XthsiVVFJcz33o5wf2OyXN9pPdu1GCRA@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/25 10:56:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/25 10:56:01,
	Serialize complete at 2013/03/25 10:56:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gao,

On 03/25/2013 10:33 AM, Lenky Gao wrote:
> [root@localhost ~]# echo 6 > /proc/irq/25/smp_affinity
> [root@localhost ~]# cat /proc/irq/25/smp_affinity
> 000006
Seems you bind the nic irq to second and third cpu for the bit mask
you set is 110, so now eth9's irq is working on the 3rd cpu.

Have you ever tried irqbalance service? It may help to balance irq if the 
irq workload of 3rd cpu is too heavy.

thanks,
linfeng
> [root@localhost ~]# cat /proc/interrupts | grep eth9
>   25:       5824      13914        159        128        210
> 0          0          0  IR-IO-APIC-fasteoi   eth9
> [root@localhost ~]# cat /proc/interrupts | grep eth9
>   25:       5824      13927        159        128        210
> 0          0          0  IR-IO-APIC-fasteoi   eth9
> [root@localhost ~]# cat /proc/interrupts | grep eth9
>   25:       5824      13939        159        128        210
> 0          0          0  IR-IO-APIC-fasteoi   eth9
> [root@localhost ~]# cat /proc/interrupts | grep eth9
>   25:       5824      13973        159        128        210
> 0          0          0  IR-IO-APIC-fasteoi   eth9
