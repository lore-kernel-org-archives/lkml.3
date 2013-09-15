Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab3IOP43 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 11:56:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757024Ab3IOP42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 11:56:28 -0400
Date: Sun, 15 Sep 2013 17:50:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Hurley <peter@hurleysoftware.com>
Cc: codonell <codonell@redhat.com>, Eduard Benes <ebenes@redhat.com>,
        Karel Srot <ksrot@redhat.com>, Matt Newsome <mnewsome@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] tty: disassociate_ctty() sends the extra SIGCONT
Message-ID: <20130915155006.GA11913@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I know nothing about tty's, I have no idea why disassociate_ctty()
checked on_exit before kill_pgrp(SIGCONT). And why this depends on
tty/old_pgrp/TTY_DRIVER_TYPE_PTY.

But this was changed in v3.10, probably by f91e2590 "tty: Signal
foreground group processes in hangup", and this breaks LSB tests
which do not expect the "wrong" SIGCONT.

The patch cc's stable, but it needs the ack or nack from someone
who these HUP/CONT rules.

IOW, I won't argue if the user-visible (and undocumented) change
added by f91e2590 is actually fine, in this case LSB should be
fixed.

Oleg.

