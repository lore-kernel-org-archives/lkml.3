Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab3DKVvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:51:39 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:33401 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061Ab3DKVvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 17:51:37 -0400
Date: Thu, 11 Apr 2013 14:51:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/9] powerpc,kvm: fix imbalance srcu_read_[un]lock()
Message-ID: <20130411215129.GU29861@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1363366257-4886-1-git-send-email-laijs@cn.fujitsu.com>
 <1363366257-4886-2-git-send-email-laijs@cn.fujitsu.com>
 <20130317212648.GA4259@iris.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130317212648.GA4259@iris.ozlabs.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041121-7408-0000-0000-00000ED32915
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 08:26:48AM +1100, Paul Mackerras wrote:
> On Sat, Mar 16, 2013 at 12:50:49AM +0800, Lai Jiangshan wrote:
> > At the point of up_out label in kvmppc_hv_setup_htab_rma(),
> > srcu read lock is still held.
> > 
> > We have to release it before return.
> > 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > Cc: Gleb Natapov <gleb@redhat.com>
> > Cc: Alexander Graf <agraf@suse.de>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: kvm@vger.kernel.org
> > Cc: kvm-ppc@vger.kernel.org
> > ---
> >  arch/powerpc/kvm/book3s_hv.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> > index 80dcc53..c26740e 100644
> > --- a/arch/powerpc/kvm/book3s_hv.c
> > +++ b/arch/powerpc/kvm/book3s_hv.c
> > @@ -1799,7 +1799,7 @@ static int kvmppc_hv_setup_htab_rma(struct kvm_vcpu *vcpu)
> >  
> >   up_out:
> >  	up_read(&current->mm->mmap_sem);
> > -	goto out;
> > +	goto out_srcu;
> 
> Acked-by: Paul Mackerras <paulus@samba.org>

Thank you both, queued for 3.11 (assuming no one has beat me to it).

							Thanx, Paul

