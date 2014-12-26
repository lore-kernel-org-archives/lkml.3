Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaLZMCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 07:02:44 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:63960 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaLZMCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 07:02:42 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Fri, 26 Dec 2014 13:02:40 +0100
Message-ID: <CA+icZUXPt=GM08PD8LOpCdxCYhNMrr-2MHxPyNRWPXqUjQXFrw@mail.gmail.com>
Subject: deb-pkg: Cleaning of debian/*tmp files when running 'make (dist)clean'
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Michal Marek <mmarek@suse.cz>, Ben Hutchings <ben@decadent.org.uk>,
        maximilian attems <max@stro.at>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I creating Debian/Ubuntu packages using builddeb script ('make deb-pkg').

While I was doing a 'make distclean' and grep-ed for some patterns I
saw that my debian/*tmp dirs were not deleted.

$ ls debian/*tmp
debian/fwtmp:
DEBIAN  lib  usr

debian/hdrtmp:
DEBIAN  lib  usr

debian/headertmp:
DEBIAN  usr

debian/tmp:
boot  DEBIAN  etc  lib  usr

Any chance that this is also done on 'make (dist)clean' (not only
within the builddeb script)?

111:rm -rf "$tmpdir" "$fwdir" "$kernel_headers_dir"
"$libc_headers_dir" "$dbg_dir"

Any other make (PHONY) target I don't know?

Or introduce sth. like clean_tmpdirs() executed before 'exit 0' (or
simply invoke above rm-line).

BTW, can we have some more meaningful var-names for both headers-dirs,
something like...

[ scripts/package/builddeb ]

-kernel_headers_dir="$objtree/debian/hdrtmp"
-libc_headers_dir="$objtree/debian/headertmp"
+kernel_headers_dir="$objtree/debian/k_hdrtmp"
+libc_headers_dir="$objtree/debian/c_hdrtmp"

...it's a bit confusing when you look at filesystem-level (dirs, files).

Thanks.

Regards,
- Sedat -
