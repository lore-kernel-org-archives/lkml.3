Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316Ab3GRGGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 02:06:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758241Ab3GRGGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 02:06:39 -0400
Date: Thu, 18 Jul 2013 09:06:28 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: markus@trippelsdorf.de, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: MMU: avoid fast page fault fixing mmio page fault
Message-ID: <20130718060628.GA15613@redhat.com>
References: <1374123157-11142-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130718053154.GY11772@redhat.com>
 <51E784CB.1040402@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E784CB.1040402@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 02:01:47PM +0800, Xiao Guangrong wrote:
> On 07/18/2013 01:31 PM, Gleb Natapov wrote:
> > On Thu, Jul 18, 2013 at 12:52:37PM +0800, Xiao Guangrong wrote:
> >> Currently, fast page fault tries to fix mmio page fault when the
> >> generation number is invalid (spte.gen != kvm.gen) and returns to
> >> guest to retry the fault since it sees the last spte is nonpresent
> >> which causes infinity loop
> >>
> >> It can be triggered only on AMD host since the mmio page fault is
> >> recognized as ept-misconfig
> >>
> > We still call into regular page fault handler from ept-misconfig
> > handler, but fake zero error_code we provide makes page_fault_can_be_fast()
> > return false.
> 
> Yes.
> 
> > 
> > Shouldn't shadow paging trigger this too? I haven't encountered this on
> > Intel without ept.
> 
> Since currently fast page fault only works for direct mmu. :)
Ah, yes. So with shadow page and paging disabled in a guest is can
happen eventually, but we do not trigger it for some reason?

--
			Gleb.
