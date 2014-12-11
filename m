Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbaLKFZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 00:25:20 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:53196 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaLKFZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 00:25:19 -0500
MIME-Version: 1.0
In-Reply-To: <20141210124254.GA25436@gmail.com>
References: <20141209132745.GA31656@gmail.com>
	<20141210124254.GA25436@gmail.com>
Date: Wed, 10 Dec 2014 21:25:18 -0800
X-Google-Sender-Auth: Rm_zXYqCefReDE4HhitEUT3Lb6E
Message-ID: <CA+55aFwiu2D=hKNvCvn-LL+TpYn9RS-N7+E8w7p+xLNdWSk8sA@mail.gmail.com>
Subject: Re: [GIT PULL, v2] x86/microcode tree changes for v3.19
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 4:42 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Please pull the latest x86-microcode-for-linus git tree from:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-microcode-for-linus

Hmm. There's a conflict with commit 02ecc41abcea ("x86, microcode:
Limit the microcode reloading to 64-bit for now"), but I'm going to
assume that the issue is fixed now, and that commit fbae4ba8c4a3
("x86, microcode: Reload microcode on resume") that causes the
conflict also handles the 32-bit case correctly. So my merge is going
to just remove the X86_64 test, effectively undoing that first commit,
ratehr than keep it around.

If it turns out that the 64-bit limitation needs to be still in place,
holler. We can re-do the ugly 64-bit limit thing if required.

                        Linus
