Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbaGNWtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 18:49:47 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:38319 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756976AbaGNWto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 18:49:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140714223918.GE5803@tassilo.jf.intel.com>
References: <1405123285-23544-1-git-send-email-andi@firstfloor.org>
	<1405123285-23544-2-git-send-email-andi@firstfloor.org>
	<CABPqkBScNfoK4a9BZkZxB-gAj3Ew2f7Ox3351YKWVt7cN-1EEw@mail.gmail.com>
	<20140714192451.GC5803@tassilo.jf.intel.com>
	<CABPqkBS=PB9tp78Y12ZRG9KLjd=DLY=3yrXeRdqCbZ4gnsdJ7A@mail.gmail.com>
	<20140714223918.GE5803@tassilo.jf.intel.com>
Date: Tue, 15 Jul 2014 00:49:43 +0200
Message-ID: <CABPqkBTYfc6CLJNzRqxDnQPr_sdv+yE9sLq717rg0sYzHhxssg@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf, x86: Don't mark DataLA addresses as store
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 12:39 AM, Andi Kleen <ak@linux.intel.com> wrote:
>> I have a problem with this patch.
>>
>> It makes: perf mem -t store rec record OP_NA for the store.
>> It was recording OP_STORE before.
>>
>> I think we need to keep LD/ST info. This is useful for analysis
>> especially if we collect loads/stores simultaneously.
>>
>> Was working before for the mem-loads, mem-stores events.
>
> Ok. Would it be enough if it only worked for "mem-stores" and not
> all PEBS events?
>
Ok, do that at a minimum.

> Otherwise have to go back to an even larger PEBS constraint
> table for HSW than before.
>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only
