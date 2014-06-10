Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbaFJIpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 04:45:49 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:57532 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaFJIpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 04:45:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140610082202.GX3213@twins.programming.kicks-ass.net>
References: <1402385858-23181-1-git-send-email-zhouzhouyi@gmail.com>
	<20140610082202.GX3213@twins.programming.kicks-ass.net>
Date: Tue, 10 Jun 2014 16:45:46 +0800
Message-ID: <CAABZP2x9ag6eAsL0si9j_TQNjM7jjTDf2UgYZ6ZtqBr2t_zQKQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] perf/amd: NULL return of kzalloc_node should be handled
From: Zhouyi Zhou <zhouzhouyi@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulus@samba.org, mingo@redhat.com, acme@kernel.org, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Peter for reviewing, and sorry for not think it thoroughly
before submitting.
Is that ok that when amd_uncore_cpu_up_prepare is called from
amd_uncore_cpu_notifier
I return notifier_from_errno(-ENOMEM), and  when
amd_uncore_cpu_up_prepare is called from
amd_uncore_init I immediately return  -ENODEV?

On Tue, Jun 10, 2014 at 4:22 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Jun 10, 2014 at 03:37:38PM +0800, Zhouyi Zhou wrote:
>
> Less typing more thinking, this is wrong. You should fail when the
> allocation fails.
