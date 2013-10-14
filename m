Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165Ab3JNP3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:29:05 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:56327 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab3JNP3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:29:01 -0400
Message-ID: <525C0DB6.2060009@redhat.com>
Date: Mon, 14 Oct 2013 17:28:54 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, glin@suse.de,
        agraf@suse.de, brogers@suse.de, afaerber@suse.de, lnussel@suse.de,
        edk2-devel@lists.sf.net, stable@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: Re: [PATCH] KVM: mmu: allow page tables to be in read-only slots
References: <1377866497-3866-1-git-send-email-pbonzini@redhat.com> <20130901091744.GF22899@redhat.com>
In-Reply-To: <20130901091744.GF22899@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 01/09/2013 11:17, Gleb Natapov ha scritto:
> This makes me think are there other places where gfn_to_hva() was
> used, but gfn_to_hva_prot() should have been?
>  - kvm_host_page_size() looks incorrect. We never use huge page to map
>    read only memory slots currently.
>  - kvm_handle_bad_page() also looks incorrect and may cause incorrect
>    address to be reported to userspace.
>  - kvm_setup_async_pf() also incorrect. Makes all page fault on read
>    only slot to be sync.
>  - kvm_vm_fault() one looks OK since function assumes write only slots,
>    but it is obsolete and should be deleted anyway.
> 
> Others in generic and x86 code looks OK, somebody need to check ppc and
> arm code.

PPC is a mess, for s390 I couldn't find a spec.  ARM needs to be fixed.
 Patches coming...

Paolo
