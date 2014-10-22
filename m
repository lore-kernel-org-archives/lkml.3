Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbaJVP33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:29:29 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:37791 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbaJVP30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:29:26 -0400
Date: Wed, 22 Oct 2014 16:29:11 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH -next 11/27] tty: Don't release tty locks for wait queue
 sanity check
Message-ID: <20141022162911.432c9bcc@alan.etchedpixels.co.uk>
In-Reply-To: <1413491125-20134-12-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
	<1413491125-20134-12-git-send-email-peter@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> However, without needing the global tty_mutex held, the tty locks for
> the releasing tty can now be held through the sleep. The sanity check
> is for abnormal conditions caused by kernel bugs, not for recoverable
> errors caused by misbehaving userspace; dropping the tty locks only
> allows the tty state to get more sideways.

An open with O_NDELAY on the closing port now appears to be able to jam
for 2 minutes ? Peviously it would at least be released by a signal.

That seems like a regression (and given the timeout is long) a bug.

Given that some code handles multiple tty devices using select and
nonblocking opens on physical ports this one bothers me a little. The old
behaviour wasn't right either (and actually stops Linux running some
modem manager type tools), but the new behaviour looks worse.

Probably though the right way to fix it is in the open path ?

Alan
