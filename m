Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479AbaGCPe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:34:59 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:46766 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbaGCPe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:34:57 -0400
MIME-Version: 1.0
In-Reply-To: <53B5863B02000078000204D5@mail.emea.novell.com>
References: <53B5863B02000078000204D5@mail.emea.novell.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 3 Jul 2014 08:34:36 -0700
Message-ID: <CALCETrW2+jYz6NXaReTsEu4pN9G-pAkF8q7p+wP3-MPruy=DsA@mail.gmail.com>
Subject: Re: [PATCH] ix86: fix vDSO build
To: Jan Beulich <JBeulich@suse.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2014 at 7:35 AM, Jan Beulich <JBeulich@suse.com> wrote:
> Relying on static functions used just once to get inlined (and
> subsequently have dead code paths eliminated) is wrong: Compilers are
> free to decide whether they do this, regardless of optimization level.
> With this not happening for vdso_addr() (observed with gcc 4.1.x), an
> unresolved reference to align_vdso_addr() causes the build to fail.
>
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Cc: Andy Lutomirski <luto@amacapital.net>

Acked-by: Andy Lutomirski <luto@amacapital.net>

Any chance you could send a dump of the symbol and relocation tables
of a .so.dbg with this problem?  I'm curious why checkundef.sh never
caught it.

--Andy
