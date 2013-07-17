Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038Ab3GQAIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 20:08:13 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:48042 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933956Ab3GQAIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 20:08:11 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrUETkBdR_Bn1ZdHCxjjnPTbQBbOCzpuM26yoQO8tnkk3Q@mail.gmail.com>
References: <CAOULuOb3-gA36S=xhA_pwLT0vf9Bb973d3Qq40KfsnS15R_qWA@mail.gmail.com>
	<CALCETrUs9Udhv7KqL+Dy8UNnHd6Amyb1mYjkC8zniF=F-RNZgw@mail.gmail.com>
	<CAOULuOZgAFv29LTZ5Zy7ZqQs+-L9OVgsB-i5vFoqiTHjC+wwQg@mail.gmail.com>
	<CALCETrUETkBdR_Bn1ZdHCxjjnPTbQBbOCzpuM26yoQO8tnkk3Q@mail.gmail.com>
Date: Tue, 16 Jul 2013 20:08:09 -0400
Message-ID: <CAOULuOYdBZwYWMPH+LJqnjj7zak2hUGLRN5z_5j5GGDcqWEXHQ@mail.gmail.com>
Subject: Re: [PATCH] BGRT: Don't ioremap if image address is in System RAM
 (was: Re: BGRT Pointer in System RAM)
From: Parag Warudkar <parag.lkml@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-acpi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 7:32 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> Fair enough.  I leave it to the experts to comment on whether there
> should be some explicit check of whether this is
> EFI_BOOT_SERVICES_DATA.
>
I am reading the code again and something doesn't sound right. The
original code calls efi_lookup_mapped_address.
It doesn't find the image address there - which is strange given that
on my system the address lies in mem type 4 as printed during boot.

Hmm. But then phys_to_virt on the same address succeeds and we can
read the image off of that.
I might need to do some debugging of efi_lookup_mapped_address to see
why it isn't finding it there. If it did find it there, none of the
ioremap issues would arise.

> FWIW, if my board does indeed have a DWORD-swapped address, it's in
> plain old RAM (type=7).

Yeah, for the status invalid case I think we would be better off just
ignoring it. Too much heuristic trickery required and it might not be
worth it after all that if the firmware didn't bother putting a proper
image in there.

Parag
