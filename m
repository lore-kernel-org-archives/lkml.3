Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab3CGHRE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 02:17:04 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:37586 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab3CGHRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 02:17:01 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFw5aqVCpsSAyy5VFhk4UwgBxKpOikVz-AC3kLJsxe0Ygw@mail.gmail.com>
References: <31680.1362588189@warthog.procyon.org.uk>
	<CA+55aFw5aqVCpsSAyy5VFhk4UwgBxKpOikVz-AC3kLJsxe0Ygw@mail.gmail.com>
Date: Thu, 7 Mar 2013 08:17:00 +0100
X-Google-Sender-Auth: 2xK3yNa3szp3HmbFsee2UJe32F4
Message-ID: <CAMuHMdWcONApHZV6J-oCkQeiyUESU9y_hpWT9cA37MGGvmgG1Q@mail.gmail.com>
Subject: Re: Byteorder conditional compilation problems
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Joakim.Tjernlund@transmode.se,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 6, 2013 at 6:37 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Mar 6, 2013 at 8:43 AM, David Howells <dhowells@redhat.com> wrote:
>> Scripting a change from "defined(__XXX_ENDIAN)" to "(__XXX_ENDIAN==__BYTEORDER)"
>> should be easy to script.
>
> How about we just make the rule be that we shouldn't test __xyz_ENDIAN
> at all, and instead always use CONFIG_xyz_ENDIAN, which isn't
> ambiguous. And then have the exporter of the uapi header files just
> sed-script that into __xyz_ENDIAN == __BYTEORDER.

I was going to suggest a checkpatch test, but your suggestion is a
better solution.
Still, we may want the checkpatch test, to make sure no one explicitly does the
moronic byte order check.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
