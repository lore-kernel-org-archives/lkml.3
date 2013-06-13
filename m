Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304Ab3FMWBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:01:00 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:57935 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab3FMWA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:00:59 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1369177867.git.luto@amacapital.net>
References: <cover.1369177867.git.luto@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 13 Jun 2013 15:00:37 -0700
Message-ID: <CALCETrW5NVQYaU1Et=wkEeUx2HcQ5kDcgW2WDJ6TAk=LYNp2oQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] x86: oops on uaccess faults outside of user addresses
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, trinity@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 2:07 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> Currently, __get_user can't trigger an OOPS -- any exception will be
> caught and return -EFAULT.  This means that, if an access_ok check is
> missing somewhere, then an attacker can freely use it to probe for valid
> kernel mappings.
>
> This series annotates all of the exception fixups as "catch anything" or
> "catch valid uaccess faults", and skips the fixup (and hence oopses) if
> an instruction of the latter type faults for any reason other than a
> page fault to a user address.
>
> I know of only one bug of this type; it's fixed in patch 5.
>
> Perhaps surprisingly, this seems to survive Trinity fairly well.
>
> Andy Lutomirski (5):
>   x86: Split "utter crap" pnpbios fixup out of fixup_exception
>   x86: Clean up extable entry format (and free up a bit)
>   x86: Annotate _ASM_EXTABLE users to distinguish uaccess from
>     everything else
>   x86: Don't fixup uaccess faults to kernel or non-canonical addresses
>   net: Block MSG_CMSG_COMPAT in send(m)msg and recv(m)msg

Patch 5 is (for better or for worse) in -linus now.  What's the status
of the other four?  (They're certainly not 3.10 material.)

--Andy
