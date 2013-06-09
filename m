Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab3FIJJW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 05:09:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543Ab3FIJJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 05:09:20 -0400
Date: Sun, 9 Jun 2013 12:09:14 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v8 00/11] KVM: MMU: fast zap all shadow pages
Message-ID: <20130609090914.GK4725@redhat.com>
References: <1369960590-14138-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130609085342.GI4725@redhat.com>
 <51B44590.7030009@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B44590.7030009@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 09, 2013 at 05:06:24PM +0800, Xiao Guangrong wrote:
> On 06/09/2013 04:53 PM, Gleb Natapov wrote:
> > On Fri, May 31, 2013 at 08:36:19AM +0800, Xiao Guangrong wrote:
> >> Hi Gleb, Paolo, Marcelo,
> >>
> >> I have putted the potential controversial patches to the latter that are
> >> patch 8 ~ 10, patch 11 depends on patch 9. Other patches are fully reviewed,
> >> I think its are ready for being merged. If not luck enough, further discussion
> >> is needed, could you please apply that patches first? :)
> >>
> >> Thank you in advance!
> >>
> >> Some points are raised during discussion but missed in this version:
> >> 1) Gleb's idea that skip obsolete pages in the hast list walker
> >>
> >>    Unfortunately, it is not safe. There has a window between updating
> >>    valid-gen and reloading mmu, in that window, the obsolete page can
> >>    be used by vcpu, but the guest page table fail to be write-protected
> >>    (since the obsolete page is skipped in mmu_need_write_protect()).
> >>
> > Can you elaborate on how this can happen. valid_gen is updated under
> > mmu_lock and reloading of mmus happens under the same lock, so for all
> > other vcpus this should look like atomic thing.
> 
> You're right.
> 
> Actually, i made another optimization patch in this version that moves
> kvm_reload_remote_mmus() out of mmu-lock, but did not attach it into this
> series. It seems my brain is not parallel-able enough. :(
Yours is the most parallel-able I ever saw :)

--
			Gleb.
