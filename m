Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752Ab3KMKti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 05:49:38 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:43105 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab3KMKtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 05:49:36 -0500
Date: Wed, 13 Nov 2013 16:08:37 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] uprobes: Fix the memory out of bound overwrite in
 copy_insn()
Message-ID: <20131113103837.GB543@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20131106191913.GA18661@redhat.com>
 <20131107075151.GB31560@gmail.com>
 <20131107143432.GA6240@redhat.com>
 <20131107151601.GA5163@gmail.com>
 <20131107162736.GA31834@redhat.com>
 <20131107194010.GA29154@redhat.com>
 <20131107194032.GB29154@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20131107194032.GB29154@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111310-9332-0000-0000-0000022259C0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-11-07 20:40:32]:

> 1. copy_insn() doesn't look very nice, all calculations are
>    confusing and it is not immediately clear why do we read
>    the 2nd page first.
> 
> 2. The usage of inode->i_size is wrong on 32-bit machines.
> 
> 3. "Instruction at end of binary" logic is simply wrong, it
>    doesn't handle the case when uprobe->offset > inode->i_size.
> 
>    In this case "bytes" overflows, and __copy_insn() writes to
>    the memory outside of uprobe->arch.insn.
> 
>    Yes, uprobe_register() checks i_size_read(), but this file
>    can be truncated after that. All i_size checks are racy, we
>    do this only to catch the obvious mistakes.
> 
> Change copy_insn() to call __copy_insn() in a loop, simplify
> and fix the bytes/nbytes calculations.
> 
> Note: we do not care if offset + size > i_size, the users of
> arch_uprobe->insn can't know how many bytes were actually copied
> anyway. But perhaps this needs more changes.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

-- 
Thanks and Regards
Srikar Dronamraju

