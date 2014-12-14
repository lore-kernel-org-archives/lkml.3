Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaLNXL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 18:11:29 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:45286 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaLNXLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 18:11:20 -0500
MIME-Version: 1.0
In-Reply-To: <20141214230208.GA9217@node.dhcp.inet.fi>
References: <20141214202224.GH2672@kvack.org>
	<CA+55aFxV2h1NrE87Zt7U8bsrXgeO=Tf-DyQO8wBYZ=M7WEjxKg@mail.gmail.com>
	<20141214215221.GI2672@kvack.org>
	<20141214141336.a0267e95.akpm@linux-foundation.org>
	<20141214230208.GA9217@node.dhcp.inet.fi>
Date: Sun, 14 Dec 2014 15:11:19 -0800
X-Google-Sender-Auth: uqcWyMa1nyoSnnYq7vhgrAcdIvk
Message-ID: <CA+55aFwxO6XyUY39=5pG3-_AHAkjxPy49wTGLAXH5_GEFCMHVg@mail.gmail.com>
Subject: Re: [GIT PULL] aio: changes for 3.19
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Pavel Emelyanov <xemul@parallels.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 3:02 PM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
>
> How can we know that it's okay to move vma around for random driver which
> provide .mmap? Or I miss something obvious?

I do think that it would likely be a good idea to require an explicit
flag somewhere before we do "move_vma()". I agree that it's kind of
odd that we just assume everything is safe to move.

That said, drivers or other random mappings that know about the
virtual address should largely be considered buggy and broken anyway.
I'm not convinced it's a good idea for aio either, but it probably has
a better excuse than  most.

                      Linus
