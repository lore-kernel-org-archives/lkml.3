Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbaGKXM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 19:12:28 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:55456 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaGKXM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 19:12:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKVuE34Ly3g885270gLQavyA0UdQZaV41HoNunRDPOC4A@mail.gmail.com>
References: <cover.1405023592.git.rgb@redhat.com> <13645924.XpBzvDVILV@sifl>
 <1405103466.2357.5.camel@flatline.rdu.redhat.com> <1433620.8yKm3TZIWM@sifl> <CAGXu5jKVuE34Ly3g885270gLQavyA0UdQZaV41HoNunRDPOC4A@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 11 Jul 2014 16:12:05 -0700
Message-ID: <CALCETrUaEcBJEzDRRX2G9e=EiSzkRYz7esx4xyqxr-aDkANdKQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] [RFC] seccomp: give BPF x32 bit when restoring x32 filter
To: Kees Cook <keescook@chromium.org>
Cc: Stephane Graber <stgraber@ubuntu.com>, Paul Moore <pmoore@redhat.com>,
        Chris Evans <cevans@google.com>, Tyler Hicks <tyhicks@canonical.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-audit@redhat.com, Will Drewry <wad@chromium.org>,
        Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Al Viro <aviro@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 11, 2014 3:48 PM, "Kees Cook" <keescook@chromium.org> wrote:
>
> On Fri, Jul 11, 2014 at 12:36 PM, Paul Moore <pmoore@redhat.com> wrote:
> > Anyway, getting back to the idea I mentioned earlier ... as many of you may
> > know, Kees (added to the CC line) is working on some seccomp filter
> > improvements which will result in a new seccomp syscall.  Perhaps one way
> > forward is to preserve everything as it is currently with the prctl()
> > interface, but with the new seccomp() based interface we fixup x32 and use the
> > new AUDIT_ARCH_X32 token?  It might result in a bit of ugliness in some of the
> > kernel, but I don't think it would be too bad, and I think it would address
> > both our concerns.
>
> Adding AUDIT_ARCH_X32: yes please. (On that note, the comment "/* Both
> x32 and x86_64 are considered "64-bit". */" should be changed...)
>

I admit I'm not convinced that the current situation is really wrong.
The "audit arch" uniquely defines a mapping between the actual syscall
and nr and the regs.  The natural way to convert between seccomp_data
and the syscall entry and regs is completely correct.

For things like ARM OABI, the situation is different: OABI and EABI
really do work differently wrt the interpretation of the syscall regs.
This isn't the case for x32.

Of course, the audit code screws this up completely, but audit is
disabled for x32.  My upcoming seccomp patchset will clean it up a
little.  IMO there's no actual audit ABI to preserve for x32, because
that code has never been anything other than terminally fvcked.

--Andy
