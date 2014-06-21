Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaFUPoI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 11:44:08 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:36014 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaFUPoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 11:44:06 -0400
MIME-Version: 1.0
In-Reply-To: <1eb40ad923acde2e18357ef2832867432e70ac42.1403361010.git.luto@amacapital.net>
References: <CA+5PVA61wwmnstiBdDemufGvXvSu4RL3WHds3NSstH-rVx7tYg@mail.gmail.com>
 <1eb40ad923acde2e18357ef2832867432e70ac42.1403361010.git.luto@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 21 Jun 2014 08:43:44 -0700
Message-ID: <CALCETrU=FAXaebS3tJF7e_fx4DZzPK_FM_A9_OaoK-+WZDqPpA@mail.gmail.com>
Subject: Re: [PATCH] x86_32,signal: Fix vdso rt_sigreturn
To: Josh Boyer <jwboyer@fedoraproject.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2014 at 7:31 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> This commit:
>
>     commit 6f121e548f83674ab4920a4e60afb58d4f61b829
>     Author: Andy Lutomirski <luto@amacapital.net>
>     Date:   Mon May 5 12:19:34 2014 -0700
>
>         x86, vdso: Reimplement vdso.so preparation in build-time C
>
> Contained this obvious typo:
>
> -               restorer = VDSO32_SYMBOL(current->mm->context.vdso, rt_sigreturn);
> +               restorer = current->mm->context.vdso +
> +                       selected_vdso32->sym___kernel_sigreturn;
>
> Note the missing 'rt_' in the new code.  Fix it.
>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>
> Compile-tested only.  I bet that someone will test it here far more quickly
> than I can figure out how to test it:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=1110968

Tested now at the link above.

--Andy
