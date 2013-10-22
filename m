Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab3JVNNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 09:13:16 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:34248 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab3JVNNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 09:13:15 -0400
MIME-Version: 1.0
From: Joao Correia <joaomiguelcorreia@gmail.com>
Date: Tue, 22 Oct 2013 14:12:34 +0100
Message-ID: <CACG0VPU5zDrYgv99Uk9SEc-+_kh2nOOBBeC14kUf+KhCoy5VtA@mail.gmail.com>
Subject: 3.11+ Problem with cifs links, bisected
To: LKML <linux-kernel@vger.kernel.org>
Cc: pshilovsky@samba.org, jlayton@redhat.com, smfrench@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list

I've been having a problem mounting windows shares with deduplicated
files (from windows 2012 deduplication), as they would show up either
garbled or 'ls' would complain it couldn't follow them.

Git bisect blames the following:
commit b42bf88828cde60772dc08201d0a4f1a0663d7bc
CIFS: Implement follow_link for SMB2
Author: Pavel Shilovsky <pshilovsky@samba.org>

dmesg doesn't complain at all.

Reverting the commit fixes the problem and the deduplicated files can
be opened perfectly, but more recent updates have been made on top of
that one and i think it can't be cleanly reverted on current -next
trees (or rcs)

If i'm not mistaken, windows 2012 treats deduplicated files as links,
but that's just what i can surmise from using it, i haven't read
anything about it's internals yet.

I've CC'ed the persons mentioned on the patch, please forward it to
anyone else that might be interested and is not on the lkml.

Thanks,
Joao Correia
