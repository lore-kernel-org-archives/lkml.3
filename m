Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab3CFRhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 12:37:38 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:48461 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab3CFRhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 12:37:36 -0500
MIME-Version: 1.0
In-Reply-To: <31680.1362588189@warthog.procyon.org.uk>
References: <31680.1362588189@warthog.procyon.org.uk>
Date: Wed, 6 Mar 2013 09:37:35 -0800
X-Google-Sender-Auth: wTaYY6NcD386kQsGmPZKItFPnLo
Message-ID: <CA+55aFw5aqVCpsSAyy5VFhk4UwgBxKpOikVz-AC3kLJsxe0Ygw@mail.gmail.com>
Subject: Re: Byteorder conditional compilation problems
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Joakim.Tjernlund@transmode.se,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 6, 2013 at 8:43 AM, David Howells <dhowells@redhat.com> wrote:
>
> Scripting a change from "defined(__XXX_ENDIAN)" to "(__XXX_ENDIAN==__BYTEORDER)"
> should be easy to script.

How about we just make the rule be that we shouldn't test __xyz_ENDIAN
at all, and instead always use CONFIG_xyz_ENDIAN, which isn't
ambiguous. And then have the exporter of the uapi header files just
sed-script that into __xyz_ENDIAN == __BYTEORDER.

The whole __xyz_ENDIAN == __BYTE_ORDER syntax is moronic, and the
standard under BSD seems to be single-underscore "_BYTE_ORDER", while
glibc uses double underscore __BYTE_ORDER. The whole thing is a
f*cking mess, and I really don't want to get the idiotic mess into the
kernel any more than I have to.

In fact, I'd prefer to let it just be. Changing it in the kernel to
the idiotic and non-standard user mode format is pointless. Just fix
up the (few) entries in the uapi header files.

                  Linus
