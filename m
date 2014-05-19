Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362AbaESOt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:49:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932302AbaESOtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:49:16 -0400
Date: Mon, 19 May 2014 15:50:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Add mem_cgroup_charge_anon() into
	uprobe_write_opcode()
Message-ID: <20140519135000.GA20010@redhat.com>
References: <20140505151320.GA25611@redhat.com> <20140519124134.GB3017@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519124134.GB3017@dhcp22.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19, Michal Hocko wrote:
>
> On Mon 05-05-14 17:13:20, Oleg Nesterov wrote:
>
> Ups, this really slipped through...
> Sorry about that.
>
> > Hugh says:
> >
> >     The one I noticed was that it forgets all about memcg (because
> >     it was copied from KSM, and there the replacement page has already
> >     been charged to a memcg). See how mm/memory.c do_anonymous_page()
> >     does a mem_cgroup_charge_anon().
> >
> > Hopefully not a big problem, uprobes is a system-wide thing and only
> > root can insert the probes. But I agree, should be fixed anyway.
>
> I am not familiar with uprobes but AFAIU this can be a non-trivial of
> (now) uncharged memory. The fact that only root is allowed to install
> probes doesn't change the fact that this is still unaccounted memory and
> so setups which are tuned to not trigger OOM killer would be broken.

Sorry for confusion. I only tried to say that a user can't exploit this
problem. And "system-wide" means that installing a uprobe has other
negative impacts on the whole system. IOW, I do not think that, say, this
fix is -stable material.

> > Add mem_cgroup_{un,}charge_anon() into uprobe_write_opcode(). To simplify
> > the error handling (and avoid the new "uncharge" label) the patch also
> > moves anon_vma_prepare() up before we alloc/charge the new page.
> >
> > While at it fix the comment about ->mmap_sem, it is held for write.
>
> > Suggested-by: Hugh Dickins <hughd@google.com>
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks!

Oleg.

