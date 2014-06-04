Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaFDUIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 16:08:52 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:33540 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaFDUIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 16:08:50 -0400
Message-ID: <538F7C7D.9040606@linux.vnet.ibm.com>
Date: Thu, 05 Jun 2014 01:37:25 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: akpm@linux-foundation.org, fweisbec@gmail.com, tglx@linutronix.de,
        hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smp, ipi: Speed up IPI handling by invoking the callbacks
 in reverse order
References: <20140604193934.21321.19185.stgit@srivatsabhat.in.ibm.com> <20140604194731.GO13930@laptop.programming.kicks-ass.net>
In-Reply-To: <20140604194731.GO13930@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060420-3568-0000-0000-000005A09DDB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 01:17 AM, Peter Zijlstra wrote:
> On Thu, Jun 05, 2014 at 01:09:35AM +0530, Srivatsa S. Bhat wrote:
>> The current implementation of lockless list (llist) has a drawback: if we
>> want to traverse the list in FIFO order (oldest to newest), we need to
>> reverse the list first (and this can be expensive if the list is large,
>> since this is an O(n) operation).
> 
> Have you actually looked at the queue depth of this thing? Large queues
> are a problem for interrupt latency.
> 

Actually, I wrote this patch just by looking at the code and realizing
that we don't need to reverse the list. In practice, I haven't actually
seen any noticeable interrupt latencies or large queues so far. So I think
this patch is just a very tiny optimization, that's all.

Regards,
Srivatsa S. Bhat

