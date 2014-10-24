Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbaJXMDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 08:03:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43879 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932374AbaJXMD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:03:28 -0400
Date: Fri, 24 Oct 2014 14:03:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Ben Harris <bjh21@bjh21.me.uk>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Don't allow stackprotector without TSC
Message-ID: <20141024120323.GA30459@pd.tnic>
References: <alpine.DEB.2.10.1410232227580.28125@snap.ds.cam.ac.uk>
 <54499287.5070803@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54499287.5070803@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 04:43:03PM -0700, Andy Lutomirski wrote:
> Presumably the actual failure is a #GP when trying to do the rdtsc. If
> so, wouldn't a better fix be to make that rdtsc check cpuid first? Can
> we easily check cpuid that early?

I don't see why not.

The real question, though is, can we have a fallback for RDTSC on those
machines so that they don't have to disable stack protector in order to
boot.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
