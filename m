Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbaDWBXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:23:48 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:36951 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbaDWBXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:23:44 -0400
MIME-Version: 1.0
In-Reply-To: <535714A1.9080502@linux.intel.com>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <1398120472-6190-1-git-send-email-hpa@linux.intel.com>
 <535714A1.9080502@linux.intel.com>
From: Andrew Lutomirski <amluto@gmail.com>
Date: Tue, 22 Apr 2014 18:23:23 -0700
Message-ID: <CAObL_7HsnpGKRoBh+NZkW7SURqGx_4Dkfow=1-_7UU9uBV4UkA@mail.gmail.com>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 6:17 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> Another spin of the prototype.  This one avoids the espfix for anything
> but #GP, and avoids save/restore/saving registers... one can wonder,
> though, how much that actually matters in practice.
>
> It still does redundant SWAPGS on the slow path.  I'm not sure I
> personally care enough to optimize that, as it means some fairly
> significant restructuring of some of the code paths.  Some of that
> restructuring might actually be beneficial, but still...
>

What's the to_dmesg thing for?

It looks sane, although I haven't checked the detailed register manipulation.

Users of big systems may complain when every single CPU lines up for
that mutex.  Maybe no one cares.

--Andy
