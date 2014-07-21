Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbaGUWAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 18:00:21 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:47273 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbaGUWAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 18:00:20 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.11.1407202330420.31021@titan.int.lan.stealer.net>
References: <alpine.LNX.2.11.1407202330420.31021@titan.int.lan.stealer.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 21 Jul 2014 14:59:58 -0700
Message-ID: <CALCETrU8xTGpOWONMnByAQo5TAqzutguw+L5_QW8K_iDe0EyeQ@mail.gmail.com>
Subject: Re: [PATCH] x86_32, entry: store badsys error code in %eax
To: Sven Wegener <sven.wegener@stealer.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
        X86 ML <x86@kernel.org>, Eric Paris <eparis@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Borislav Petkov <bp@alien8.de>,
        =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>,
        stable <stable@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
        Josh Boyer <jwboyer@fedoraproject.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 2:33 PM, Sven Wegener <sven.wegener@stealer.net> wrote:
> Commit 554086d ("x86_32, entry: Do syscall exit work on badsys
> (CVE-2014-4508)") introduced a subtle regression in the x86_32 syscall
> entry code, resulting in syscall() not returning proper errors for
> non-existing syscalls on CPUs not supporting the sysenter feature.

s/not supporting/supporting/

That means that this is IMO much worse than the other way around: all
newish 32-bit systems are affected.

Other than the typo and the missing Cc: stable:

Reviewed-and-tested-by: Andy Lutomirski <luto@amacapital.net>

--Andy
