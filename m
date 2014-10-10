Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaJJI7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 04:59:25 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:50737 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaJJI7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 04:59:04 -0400
Date: Fri, 10 Oct 2014 09:58:28 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: David Laight <David.Laight@ACULAB.COM>, Arnd Bergmann <arnd@arndb.de>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH tty-next 14/22] tty: Remove
 tty_wait_until_sent_from_close()
Message-ID: <20141010095828.1f0de28b@alan.etchedpixels.co.uk>
In-Reply-To: <5434B5D3.4060308@hurleysoftware.com>
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
	<1402924639-5164-15-git-send-email-peter@hurleysoftware.com>
	<4575870.N9RCpZ4UMg@wuerfel>
	<53A01F02.7000202@hurleysoftware.com>
	<063D6719AE5E284EB5DD2968C1650D6D1725DAF6@AcuExch.aculab.com>
	<5434B5D3.4060308@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The point being that holding the tty lock across the _entire_ close
> is equivalent to the current outcome, regardless of O_NONBLOCK.
> 
> I'm reluctant to start returning EGAIN for non-blocking tty opens
> because no tty driver does that now, and I don't think userspace will
> deal well with new return codes from tty opens.

I do not know about the non blocking case mattering. The blocking open
does need to wait, when I broke that case before I broke the console
login drivers (mingetty).

Returning EAGAIN would also only work if poll/select did the right thing.
Currently Linux can't support a System5 style ttymon process because of
this limitation, which means, for example, that systemd can't implement a
single thread to manage all console prompts/setup

Alan
