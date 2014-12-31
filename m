Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbaLaVXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 16:23:16 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:61123 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaLaVXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 16:23:15 -0500
MIME-Version: 1.0
In-Reply-To: <3159430.4MhUX0bhoZ@sifl>
References: <3159430.4MhUX0bhoZ@sifl>
Date: Wed, 31 Dec 2014 13:23:14 -0800
X-Google-Sender-Auth: BOiW0FqlthRS0lHq0sH2li_3iTw
Message-ID: <CA+55aFzwqafHa6ARO-zkCDaHZozZDDvETBMmbnvNsnu1L9v2=w@mail.gmail.com>
Subject: Re: [GIT PULL] Audit fixes for 3.19 #2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul Moore <paul@paul-moore.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-audit@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 12:33 PM, Paul Moore <paul@paul-moore.com> wrote:
>
> One audit patch to resolve a panic/oops when recording filenames in the audit
> log, see the mail archive link below.  The fix isn't as nice as I would like,
> as it involves an allocate/copy of the filename, but it solves the problem and
> the overhead should only affect users who have configured audit rules
> involving file names.

This fix looks wrong.

The kernel "getname()" function already has hacks explicitly for this
audit usage. Why aren't those hacks working? See the whole
"audit_getname()" and "audit_putname()" thing in fs/namei.c.

So why does audit now need to copy the name *again*, when the whole -
and only - point of the current fs/namei.c audit hackery is exactly so
that audit can control the lifetime of the pathnames?

Hmm? Alternatively, could we just remove the fs/namei.c hackery
entirely, and rely on audit always copying the filenames for its own
use?

                      Linus
