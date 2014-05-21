Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaEUKFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 06:05:23 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:50582 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaEUKFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 06:05:17 -0400
Date: Wed, 21 May 2014 15:35:06 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>, Hugh Dickins <hughd@google.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Add mem_cgroup_charge_anon() into
 uprobe_write_opcode()
Message-ID: <20140521100506.GC29630@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140505151320.GA25611@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20140505151320.GA25611@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052110-6102-0000-0000-000005A0339B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2014-05-05 17:13:20]:

> Hugh says:
> 
>     The one I noticed was that it forgets all about memcg (because
>     it was copied from KSM, and there the replacement page has already
>     been charged to a memcg). See how mm/memory.c do_anonymous_page()
>     does a mem_cgroup_charge_anon().
> 
> Hopefully not a big problem, uprobes is a system-wide thing and only
> root can insert the probes. But I agree, should be fixed anyway.
> 
> Add mem_cgroup_{un,}charge_anon() into uprobe_write_opcode(). To simplify
> the error handling (and avoid the new "uncharge" label) the patch also
> moves anon_vma_prepare() up before we alloc/charge the new page.
> 
> While at it fix the comment about ->mmap_sem, it is held for write.
> 
> Suggested-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

-- 
Thanks and Regards
Srikar Dronamraju

