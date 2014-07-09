Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbaGIWOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 18:14:30 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:64389 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaGIWO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 18:14:29 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 9 Jul 2014 15:14:07 -0700
Message-ID: <CALCETrVabs3d1ERN=im+bKLtjT7r9PSA4r+xwBwZS0UK=Zxw9Q@mail.gmail.com>
Subject: signal frame ss in a 64-bit process?
To: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How is restoring ss and ds in a 64-bit process supposed to work?
There's this comment:

        /* Kernel saves and restores only the CS segment register on signals,
         * which is the bare minimum needed to allow mixed 32/64-bit code.
         * App's signal handler can save/restore other segments if needed. */

AFAICT this is bogus: syscall (the 64-bit version) sets regs->ss to
__USER_DS.  I think that the actual ss register is untouched until the
syscall returns, so in theory sigreturn could copy ss to regs, but
that seems kind of nasty.

Can we steal __pad0 and put ss in there?

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
