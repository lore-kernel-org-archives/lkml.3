Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab3CQV06 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 17:26:58 -0400
Received: from ozlabs.org ([203.10.76.45]:34634 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932325Ab3CQV0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 17:26:55 -0400
Date: Mon, 18 Mar 2013 08:26:48 +1100
From: Paul Mackerras <paulus@samba.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/9] powerpc,kvm: fix imbalance srcu_read_[un]lock()
Message-ID: <20130317212648.GA4259@iris.ozlabs.ibm.com>
References: <1363366257-4886-1-git-send-email-laijs@cn.fujitsu.com>
 <1363366257-4886-2-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363366257-4886-2-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 12:50:49AM +0800, Lai Jiangshan wrote:
> At the point of up_out label in kvmppc_hv_setup_htab_rma(),
> srcu read lock is still held.
> 
> We have to release it before return.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: Gleb Natapov <gleb@redhat.com>
> Cc: Alexander Graf <agraf@suse.de>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: kvm@vger.kernel.org
> Cc: kvm-ppc@vger.kernel.org
> ---
>  arch/powerpc/kvm/book3s_hv.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 80dcc53..c26740e 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -1799,7 +1799,7 @@ static int kvmppc_hv_setup_htab_rma(struct kvm_vcpu *vcpu)
>  
>   up_out:
>  	up_read(&current->mm->mmap_sem);
> -	goto out;
> +	goto out_srcu;

Acked-by: Paul Mackerras <paulus@samba.org>
