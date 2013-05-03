Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762077Ab3ECCKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 22:10:37 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:48088 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab3ECCKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 22:10:36 -0400
Date: Fri, 3 May 2013 11:10:31 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: mtosatti@redhat.com, gleb@redhat.com, avi.kivity@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 2/6] KVM: x86: introduce memslot_set_lpage_disallowed
Message-Id: <20130503111031.344825656c22e2c58f759cf1@gmail.com>
In-Reply-To: <1367032402-13729-3-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1367032402-13729-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
	<1367032402-13729-3-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Apr 2013 11:13:18 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> It is used to set disallowed large page on the specified level, can be
> used in later patch
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/x86.c |   53 ++++++++++++++++++++++++++++++++++-----------------
>  1 files changed, 35 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 91dd9f4..52b4e97 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6917,12 +6917,45 @@ void kvm_arch_free_memslot(struct kvm_memory_slot *free,
>  	}
>  }
>  
> +static void memslot_set_lpage_disallowed(struct kvm_memory_slot *slot,
> +					 unsigned long npages,
> +					 int lpage_size, int lpages)

What this function does is to disable large page support for this slot
as can be seen in the comment below.

Since setting lpage_info to something ("disallowed" ?) is an implementation
detail, we'd better hide such a thing from the function name.

Taking into account that we have "kvm_largepages_enabled()", something like
disable_largepages_memslot() may be a candidate.

But I want to see suggestions from others as well.

	Takuya
