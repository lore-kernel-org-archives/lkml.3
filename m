Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbbAZQcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:32:22 -0500
Received: from mail-oi0-f49.google.com ([209.85.218.49]:36015 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbbAZQcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:32:18 -0500
MIME-Version: 1.0
In-Reply-To: <CA+5PVA7rVy6Li_1haj1QmGG0D6avLB5Xej=2YGt6K-11kKHR5A@mail.gmail.com>
References: <CA+5PVA7rVy6Li_1haj1QmGG0D6avLB5Xej=2YGt6K-11kKHR5A@mail.gmail.com>
Date: Mon, 26 Jan 2015 11:32:17 -0500
X-Google-Sender-Auth: ZyQNTOCXjgc1iATDxPyJTI9kn9M
Message-ID: <CA+5PVA4bs6CYU8MHn1JqBjnb-5wYJT2Tjqa65=v2uSPL8c7dYw@mail.gmail.com>
Subject: Re: patch-2.7.3 no longer applies relative symbolic link patches
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, gitster@pobox.com
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        twaugh@redhat.com, Git Mailing List <git@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding Junio's correct email address.  Sigh.]

On Mon, Jan 26, 2015 at 11:29 AM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> Hi,
>
> I went to do the Fedora 3.19-rc6 build this morning and it failed in
> our buildsystem with:
>
> + '[' '!' -f /builddir/build/SOURCES/patch-3.19-rc6.xz ']'
> + case "$patch" in
> + unxz
> + patch -p1 -F1 -s
> symbolic link target '../../../../../include/dt-bindings' is invalid
> error: Bad exit status from /var/tmp/rpm-tmp.mWE3ZL (%prep)
>
> That is coming from the hunk in patch-3.19-rc6.xz that creates the
> symbolic link from arch/arm64/boot/dts/include/dt-bindings to
> include/dt-bindings.  Oddly enough, patch-3.19-rc5.xz contains the
> same hunk and it built fine last week.
>
> Digging in, it seems that upstream patch has decided that relative
> symlinks are forbidden now as part of a fix for CVE-2015-1196.  You
> can find the relevant bugs here:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=1185928
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=775901#13
>
> Aside from locally modifying patch-3.19-rc6.xz, I'm not sure what else
> to do.  I thought I would send a heads up since anyone that is using
> patch-2.7.3 is probably going to run into this issue.
>
> josh
