Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648AbaFQIBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 04:01:05 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:51397 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbaFQIBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 04:01:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@lists.ozlabs.org
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Karsten Keil <isdn@linux-pingi.de>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH tty-next 14/22] tty: Remove tty_wait_until_sent_from_close()
Date: Tue, 17 Jun 2014 10:00:59 +0200
Message-ID: <4575870.N9RCpZ4UMg@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1402924639-5164-15-git-send-email-peter@hurleysoftware.com>
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com> <1402924639-5164-15-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Aj4HE/j0S6mdoRSy1soI4mvj18an5D+fXIv7IOtYFL4
 ubkEsjiWORnGJvDcaWwKjV1BZmgA9mKvPvweDH2a8jPGJP8+ri
 lVIKExr+0h4zN187fdl+IPlwk0u+Zsljak86HzxU+yNwUP1UBS
 deTIFNsmSZun61NPG5AfE2rlVjRkxQCQL6/fZpD2Q1424IB90J
 lsPx5CYfsUgwWokJWK9gpvGScWQfB3awFxKSVs7AAeNfXr5K0D
 KOJgy0Y1OJfaDWmjPAI5eFKnXuE6MZ/Exa5m2d3SL6WtWh5MKf
 BGbeuVJ3ZpM59k4ZcV/582ccCN+zl7B6YPYGWyEUOujEcyclrJ
 bgbVyLUcaanqh4RDspww=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 June 2014 09:17:11 Peter Hurley wrote:
> tty_wait_until_sent_from_close() drops the tty lock while waiting
> for the tty driver to finish sending previously accepted data (ie.,
> data remaining in its write buffer and transmit fifo).
> 
> However, dropping the tty lock is a hold-over from when the tty
> lock was system-wide; ie., one lock for all ttys.
> 
> Since commit 89c8d91e31f267703e365593f6bfebb9f6d2ad01,
> 'tty: localise the lock', dropping the tty lock has not been necessary.
> 
> CC: Karsten Keil <isdn@linux-pingi.de>
> CC: linuxppc-dev@lists.ozlabs.org
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>

I don't understand the second half of the changelog, it doesn't seem
to fit here: there deadlock that we are trying to avoid here happens
when the *same* tty needs the lock to complete the function that
sends the pending data. I don't think we do still do that any more,
but it doesn't seem related to the tty lock being system-wide or not.

	Arnd
