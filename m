Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab3CYFRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 01:17:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64253 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757296Ab3CYFRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 01:17:22 -0400
X-IronPort-AV: E=Sophos;i="4.87,343,1363104000"; 
   d="scan'208";a="6936778"
Message-ID: <514FDE5F.5020500@cn.fujitsu.com>
Date: Mon, 25 Mar 2013 13:19:27 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lenky Gao <lenky.gao@gmail.com>
CC: linux-kernel@vger.kernel.org, yinghai@kernel.org, mingo@elte.hu,
        gorcunov@gmail.com, rusty@rustcorp.com.au, sivanich@sgi.com,
        agordeev@redhat.com
Subject: Re: Question: How to distribute the interrupts over multiple cores?
References: <CAAO_Xo6=2PKumrxjb1XthsiVVFJcz33o5wf2OyXN9pPdu1GCRA@mail.gmail.com> <514FBD6E.2030706@cn.fujitsu.com> <CAAO_Xo7edAuiGQaXHuyWB5RPgPd5dDDRof3-d28eu+mryJkv+Q@mail.gmail.com> <514FC385.4030008@cn.fujitsu.com> <CAAO_Xo7FbEsG=6pmcfUDyKtcPuPLTkNY+kUU+5hFnzciQBO-Aw@mail.gmail.com>
In-Reply-To: <CAAO_Xo7FbEsG=6pmcfUDyKtcPuPLTkNY+kUU+5hFnzciQBO-Aw@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/25 13:16:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/25 13:16:36,
	Serialize complete at 2013/03/25 13:16:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/25/2013 11:44 AM, Lenky Gao wrote:
>> On 03/25/2013 11:18 AM, Lenky Gao wrote:
>>> The irqbalance service has been stopped.
>> So try start irqbalance to see what happen?
>> It should help to give what you want ;-)
> 
> Using the irqbalance service to dynamically change the IRQ-bound? It's
> seems a software solution. In my old machine, there is no this
> problem. I need some information to explain why. Maybe is the

Do you mean on your old machine the irq will be distributed automatically 
among the cpus set by smp_affinity?

Sorry, I forgot one thing that the irqbalance service will break the mask
set by smp_affinity. So I don't know if now we support the feature
that balance among the cpus set by smp_affinity.
 
In my old conception when we set smp_affinity the irqbalance service
should be stopped, so you are right before, and the kernel will choose
one cpu in your mask for the IRQ and bounded from now on if there is no
irqbalance service.

thanks,
linfeng 
