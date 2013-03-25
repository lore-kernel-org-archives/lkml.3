Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247Ab3CYJjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 05:39:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50936 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab3CYJjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 05:39:02 -0400
X-IronPort-AV: E=Sophos;i="4.87,344,1363104000"; 
   d="scan'208";a="6939713"
Message-ID: <51501BB6.5000306@cn.fujitsu.com>
Date: Mon, 25 Mar 2013 17:41:10 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lenky Gao <lenky.gao@gmail.com>
CC: linux-kernel@vger.kernel.org, yinghai@kernel.org, mingo@elte.hu,
        gorcunov@gmail.com, rusty@rustcorp.com.au, sivanich@sgi.com,
        agordeev@redhat.com
Subject: Re: Question: How to distribute the interrupts over multiple cores?
References: <CAAO_Xo6=2PKumrxjb1XthsiVVFJcz33o5wf2OyXN9pPdu1GCRA@mail.gmail.com> <514FBD6E.2030706@cn.fujitsu.com> <CAAO_Xo7edAuiGQaXHuyWB5RPgPd5dDDRof3-d28eu+mryJkv+Q@mail.gmail.com> <514FC385.4030008@cn.fujitsu.com> <CAAO_Xo7FbEsG=6pmcfUDyKtcPuPLTkNY+kUU+5hFnzciQBO-Aw@mail.gmail.com> <514FDE5F.5020500@cn.fujitsu.com> <CAAO_Xo6dG8C_-e4mHuKm12vQ7MVoYR8fPggK00T28i0JzqpDyA@mail.gmail.com> <514FF70A.6080402@cn.fujitsu.com> <CAAO_Xo5bbABJOPrC43GtKw3m=bUtqzALoHSHz=f_Dj0QFobqgg@mail.gmail.com> <CAAO_Xo7CTzow1TN+4bmmHH9KB4NSLRv5ZsOmwEC2KGTxDc-1Ug@mail.gmail.com>
In-Reply-To: <CAAO_Xo7CTzow1TN+4bmmHH9KB4NSLRv5ZsOmwEC2KGTxDc-1Ug@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/25 17:38:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/25 17:38:17,
	Serialize complete at 2013/03/25 17:38:17
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/25/2013 05:00 PM, Lenky Gao wrote:
> I have found a comment in function physflat_cpu_mask_to_apicid to explain why.
> 
> static unsigned int physflat_cpu_mask_to_apicid(const struct cpumask *cpumask)
> {
> 	int cpu;
> 
> 	/*
> 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
> 	 * May as well be the first.
> 	 */
> ...
> 
> This is mean i can not distribute the interrupts over multiple cores
> when the machine have more than 8 cores?
> 
> 
Sorry I can't find physflat_cpu_mask_to_apicid() in latest Linux tree, seems it has
been removed out.. But just consider what you said that it's limited by "8 cores"
IMHO it's impossible or it is a bug.

thanks,
linfeng
