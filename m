Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbbAYMIp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 07:08:45 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:35737 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbbAYMIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 07:08:41 -0500
MIME-Version: 1.0
In-Reply-To: <54C4D6BA.4080308@ahsoftware.de>
References: <54C2F4F8.20809@draigBrady.com>
	<1422096327-4483-1-git-send-email-holler@ahsoftware.de>
	<54C383E0.9060408@ahsoftware.de>
	<54C38B6D.1060806@ahsoftware.de>
	<54C3901D.8040406@ahsoftware.de>
	<54C45153.2050703@draigBrady.com>
	<54C4583A.5040505@ahsoftware.de>
	<54C4C65A.2020403@ahsoftware.de>
	<54C4CC05.9090602@ahsoftware.de>
	<54C4D6BA.4080308@ahsoftware.de>
Date: Sun, 25 Jan 2015 13:08:40 +0100
Message-ID: <CAFLxGvzZOfhwW5hp1GDhTHLU5Z=9ozkOQgvatqhwDT982hfYcA@mail.gmail.com>
Subject: Re: [PATCH v2] modsign: use shred to overwrite the private key before
 deleting it
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: =?UTF-8?Q?P=C3=A1draig_Brady?= <P@draigbrady.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2015 at 12:42 PM, Alexander Holler <holler@ahsoftware.de> wrote:
> Now, after I ended up into flaming a lot (sorry again, but this topic made
> me angry for so long and I had to spent too much time to get rid of unwanted
> content and answering other peoples question in regard to that topic), I
> should offer something more useful.
>
> So I've written down in some short words, how I think it could be done:
>
> First offer a syscall named sunlink() (or whatever name) which fails if it
> can't overwrite or securely trim the contents of a file before deleting it.
>
> That could be done like this:
>
> (1) If it's a SSD or MMC without offering "Secure Trim" fail.
> (2) If it's a plain FLASH or conventional harddisk where writing a block
> means that block will be overwritten or if it's a SSD or MMC with "Secure
> Trim) go on with
> (3) Identify the blocks which contain the file contents (should be doable by
> using the same mechanisms used to read and write a file)
> (4) Mark the file as deleted
> (5) Overwrite or securely trim blocks which can be deleted completely
> (6) Build new blocks for blocks which can only partly deleted because they
> contain information still used by the FS or other files
> (7) Instruct the FS to us the new blocks instead of the old ones
> (8) Overwrite or securely trim the old blocks which previously contained
> partly information of other stuff.
>
> Afterwards use that new syscall in shred.
>
> Of course, this is just a totally simplified instruction in regard to how
> complicated filesystems have become, but I think there isn't any black magic
> involved in offering the user a simple way to really delete files.

Or add support for the "s" chattr to major filesystems.
