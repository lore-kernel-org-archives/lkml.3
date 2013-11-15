Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab3KOAXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 19:23:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab3KOAW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 19:22:59 -0500
Date: Thu, 14 Nov 2013 22:08:47 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 05/15] KVM: MMU: update spte and add it into rmap
 before dirty log
Message-ID: <20131115000847.GA7219@amt.cnet>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1382534973-13197-6-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382534973-13197-6-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 09:29:23PM +0800, Xiao Guangrong wrote:
> kvm_vm_ioctl_get_dirty_log() write-protects the spte based on the its dirty
> bitmap, so we should ensure the writable spte can be found in rmap before the
> dirty bitmap is visible. Otherwise, we clear the dirty bitmap but fail to
> write-protect the page which is detailed in the comments in this patch
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c | 84 ++++++++++++++++++++++++++++++++++++++++++------------
>  arch/x86/kvm/x86.c | 10 +++++++
>  2 files changed, 76 insertions(+), 18 deletions(-)

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>

