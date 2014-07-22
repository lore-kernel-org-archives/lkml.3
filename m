Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbaGVWNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:13:09 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:57018 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978AbaGVWNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:13:06 -0400
Date: Tue, 22 Jul 2014 15:13:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nick Krause <xerofoify@gmail.com>
cc: Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, gleb@kernel.org, pbonzini@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] x86: Remove Fix me in main.c and add include statement
 for kvm_para.h
In-Reply-To: <CAPDOMVj4Rg7YyfErabfAuGdbJG7Owbh3k8AGgTVODcb1jfTGuQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1407221512140.5814@chino.kir.corp.google.com>
References: <1406065658-3866-1-git-send-email-xerofoify@gmail.com> <alpine.DEB.2.02.1407221506240.5814@chino.kir.corp.google.com> <CAPDOMVj4Rg7YyfErabfAuGdbJG7Owbh3k8AGgTVODcb1jfTGuQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2014, Nick Krause wrote:

> >> This patch removes a fix me by including linux/types.h in kvm_para.h
> >> as stated by the  fix me in main.c and also removes the comment from
> >> main.c too.
> >>
> >> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> >> ---
> >>  arch/x86/kernel/cpu/mtrr/main.c | 2 +-
> >>  include/linux/kvm_para.h        | 3 +--
> >>  2 files changed, 2 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
> >> index f961de9..7ba314b 100644
> >> --- a/arch/x86/kernel/cpu/mtrr/main.c
> >> +++ b/arch/x86/kernel/cpu/mtrr/main.c
> >> @@ -33,7 +33,7 @@
> >>
> >>  #define DEBUG
> >>
> >> -#include <linux/types.h> /* FIXME: kvm_para.h needs this */
> >> +#include <linux/types.h>
> >>
> >>  #include <linux/stop_machine.h>
> >>  #include <linux/kvm_para.h>
> >> diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
> >> index 00a97bb..21d1be2 100644
> >> --- a/include/linux/kvm_para.h
> >> +++ b/include/linux/kvm_para.h
> >> @@ -2,8 +2,7 @@
> >>  #define __LINUX_KVM_PARA_H
> >>
> >>  #include <uapi/linux/kvm_para.h>
> >> -
> >> -
> >> +#include <linux/types.h>
> >>  static inline int kvm_para_has_feature(unsigned int feature)
> >>  {
> >>       if (kvm_arch_para_features() & (1UL << feature))
> >
> > There's no build error reported that would indicate that this is needed,
> > so this patch isn't justifiable.
> 
> 
> David,
> 
> Good to hear a nicer reply after my stupid patch with page shifts.
> Would you like me to send in a patch that removes this fix me
> then?

The comment is not the only thing that can be removed in the above patch.  
If you test the change and can prove why it's not needed in the changelog, 
then such a patch would be worthwhile.
