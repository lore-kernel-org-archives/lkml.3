Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab3KBOCg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 10:02:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab3KBOCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 10:02:35 -0400
Date: Sat, 2 Nov 2013 15:03:39 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/13] uprobes: add arch write opcode hook
Message-ID: <20131102140339.GA17575@redhat.com>
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org> <1381871068-27660-6-git-send-email-dave.long@linaro.org> <20131019165051.GC7837@redhat.com> <5268137F.3030809@linaro.org> <20131028194914.GA15103@redhat.com> <20131029195920.GA4538@redhat.com> <52747280.7040708@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52747280.7040708@linaro.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01, David Long wrote:
>
> On 10/29/13 15:59, Oleg Nesterov wrote:
>>
>> Or. arm can actually reimplement set_swbp(). This doesn't mean the
>> duplication of write_opcode() code, we can simply export this helper.
>>
>
> That actually looks to me like the cleanest approach.  I have changed
> the static write_opcode() to a global uprobe_write_opcode(), and now
> call it from an arm set_swbp().

OK, great.

> Please do *not* make set_swbp() (and set_orig_insn()) static's.  It
> looks like we now have a use for at least one of them.

I am not sure... it still seems to me it makes sense to cleanup this
interface...

But. I am not going to do this until we merge your changes. We will
see then.

Oleg.

