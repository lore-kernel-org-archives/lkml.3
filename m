Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584AbbA1URW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:17:22 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:46334 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410AbbA1URQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:17:16 -0500
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH 3.14 26/77] KVM: x86: Fix of previously incomplete fix for CVE-2014-8480
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20150128012746.755133889@linuxfoundation.org>
Date: Wed, 28 Jan 2015 10:51:10 +0200
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <B926DEE6-9627-4EB2-9A08-1C80675E8366@gmail.com>
References: <20150128012745.971137091@linuxfoundation.org> <20150128012746.755133889@linuxfoundation.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This CVE only affect 3.17 and 3.18. It shouldn’t hurt, but you can omit this
patch from 3.14.

Regards,
Nadav

Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> 3.14-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Nadav Amit <nadav.amit@gmail.com>
> 
> commit 63ea0a49ae0b145b91ff2b070c01b66fc75854b9 upstream.
> 
> STR and SLDT with rip-relative operand can cause a host kernel oops.
> Mark them as DstMem as well.
> 
> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
> arch/x86/kvm/emulate.c |    4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -3668,8 +3668,8 @@ static const struct opcode group5[] = {
> };
> 
> static const struct opcode group6[] = {
> -	DI(Prot,	sldt),
> -	DI(Prot,	str),
> +	DI(Prot | DstMem,	sldt),
> +	DI(Prot | DstMem,	str),
> 	II(Prot | Priv | SrcMem16, em_lldt, lldt),
> 	II(Prot | Priv | SrcMem16, em_ltr, ltr),
> 	N, N, N, N,


