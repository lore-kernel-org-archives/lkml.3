Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaGLCV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 22:21:56 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:48549 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbaGLCVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 22:21:55 -0400
MIME-Version: 1.0
In-Reply-To: <a13ebdd57378120348f40cbe12d9b1705d189434.1405095200.git.luto@amacapital.net>
References: <cover.1405095200.git.luto@amacapital.net>
	<a13ebdd57378120348f40cbe12d9b1705d189434.1405095200.git.luto@amacapital.net>
Date: Fri, 11 Jul 2014 19:21:54 -0700
X-Google-Sender-Auth: CxiyODn75IU-nlFriTiOEVItFQk
Message-ID: <CA+55aFxc1FWkSzRmtRP3XhEJ1Y1p8bc3SiTShhskwjRLJkTazA@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86_64,signal: Remove 'fs' and 'gs' from sigcontext
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 9:29 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> As far as I can tell, these fields have been set to zero on save and
> ignored on restore since Linux was imported into git.  Rename them
> '__pad1' and '__pad2' to avoid confusion and to allow them to be
> recycled some day.

Shouldn't we actually try to save/restore gs/fs properly? Admittedly,
changing them in the signal handler would be insane, but still.. See
our context switching code  with the whole segment selector vs base
save/restore code. Hmm?

            Linus
