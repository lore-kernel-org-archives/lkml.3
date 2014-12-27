Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681AbaL0TeG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 14:34:06 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51435 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaL0TeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 14:34:01 -0500
Message-ID: <549F09A2.2050903@redhat.com>
Date: Sat, 27 Dec 2014 20:33:54 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.comp.emulators.kvm.devel
To: "Chen, Tiejun" <tiejun.chen@intel.com>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        luto@amacapital.net, jamie@audible.transient.net
Subject: Re: regression bisected; KVM: entry failed, hardware error 0x80000021
References: <20141221124640.GA4059@cucamonga.audible.transient.net> <5497C882.4000108@intel.com> <20141222092358.GA3915@cucamonga.audible.transient.net> <5498CA50.8070906@intel.com> <5498CB62.3070901@intel.com> <20141223072659.GA4015@cucamonga.audible.transient.net> <549A796C.50801@intel.com> <20141224110239.GA3908@cucamonga.audible.transient.net> <549BC0D9.6040801@intel.com>
In-Reply-To: <549BC0D9.6040801@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 25/12/2014 08:46, Chen, Tiejun wrote:
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f528343..910bc48 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -672,6 +672,7 @@ static void update_memslots(struct kvm_memslots *slots,
>         WARN_ON(mslots[i].id != id);
>         if (!new->npages) {
>                 new->base_gfn = 0;
> +               new->flags = 0;
>                 if (mslots[i].npages)
>                         slots->used_slots--;
>         } else {

Why is this assignment needed?

Paolo
