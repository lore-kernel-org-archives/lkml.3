Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab3CYJAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 05:00:06 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:47311 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab3CYJAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 05:00:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAAO_Xo5bbABJOPrC43GtKw3m=bUtqzALoHSHz=f_Dj0QFobqgg@mail.gmail.com>
References: <CAAO_Xo6=2PKumrxjb1XthsiVVFJcz33o5wf2OyXN9pPdu1GCRA@mail.gmail.com>
	<514FBD6E.2030706@cn.fujitsu.com>
	<CAAO_Xo7edAuiGQaXHuyWB5RPgPd5dDDRof3-d28eu+mryJkv+Q@mail.gmail.com>
	<514FC385.4030008@cn.fujitsu.com>
	<CAAO_Xo7FbEsG=6pmcfUDyKtcPuPLTkNY+kUU+5hFnzciQBO-Aw@mail.gmail.com>
	<514FDE5F.5020500@cn.fujitsu.com>
	<CAAO_Xo6dG8C_-e4mHuKm12vQ7MVoYR8fPggK00T28i0JzqpDyA@mail.gmail.com>
	<514FF70A.6080402@cn.fujitsu.com>
	<CAAO_Xo5bbABJOPrC43GtKw3m=bUtqzALoHSHz=f_Dj0QFobqgg@mail.gmail.com>
Date: Mon, 25 Mar 2013 17:00:03 +0800
Message-ID: <CAAO_Xo7CTzow1TN+4bmmHH9KB4NSLRv5ZsOmwEC2KGTxDc-1Ug@mail.gmail.com>
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

I have found a comment in function physflat_cpu_mask_to_apicid to explain why.

static unsigned int physflat_cpu_mask_to_apicid(const struct cpumask *cpumask)
{
	int cpu;

	/*
	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
	 * May as well be the first.
	 */
...

This is mean i can not distribute the interrupts over multiple cores
when the machine have more than 8 cores?


-- 
Regards,

Lenky
