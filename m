Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3FJRDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 13:03:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095Ab3FJRDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 13:03:46 -0400
Date: Mon, 10 Jun 2013 20:03:41 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/6] KVM: MMU: fast invalidate all mmio sptes
Message-ID: <20130610170341.GJ29022@redhat.com>
References: <1370595088-3315-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130610075656.GY4725@redhat.com>
 <51B590C9.9080009@gmail.com>
 <20130610224352.0a769838745b294fc43f7823@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130610224352.0a769838745b294fc43f7823@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 10:43:52PM +0900, Takuya Yoshikawa wrote:
> On Mon, 10 Jun 2013 16:39:37 +0800
> Xiao Guangrong <xiaoguangrong.eric@gmail.com> wrote:
> 
> > On 06/10/2013 03:56 PM, Gleb Natapov wrote:
> > > On Fri, Jun 07, 2013 at 04:51:22PM +0800, Xiao Guangrong wrote:
> 
> > > Looks good to me, but doesn't tis obsolete kvm_mmu_zap_mmio_sptes() and
> > > sp->mmio_cached, so they should be removed as part of the patch series?
> > 
> > Yes, i agree, they should be removed. :)
> 
> I'm fine with removing it but please make it clear that you all agree
> on the same basis.
> 
> Last time, Paolo mentioned the possibility to use some bits of spte for
> other things.  The suggestion there was to keep sp->mmio_cached code
> for the time we would need to reduce the bits for generation numbers.
> 
> Do you think that zap_all() is now preemptible and can treat the
> situation reasonably well as the current kvm_mmu_zap_mmio_sptes()?
> 
> One downside is the need to zap unrelated shadow pages, but if this case
> is really very rare, yes I agree, it should not be a problem: it depends
> on how many bits we can use.
> 
> Just please reconfirm.
> 
That was me who mention the possibility to use some bits of spte for
other things. But for now I have a use for one bit only. Now that you
have reminded me about that discussion I am not so sure we want to
remove kvm_mmu_zap_mmio_sptes(), but on the other hand it is non
preemptable, so large number of mmio sptes can cause soft lockups.
zap_all() is better in this regards now.

--
			Gleb.
