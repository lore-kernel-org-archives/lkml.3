Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbaFQLzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 07:55:39 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39860 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaFQLzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 07:55:37 -0400
Date: Tue, 17 Jun 2014 12:54:41 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: David Laight <David.Laight@aculab.com>,
        "'Peter Hurley'" <peter@hurleysoftware.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH tty-next 14/22] tty: Remove
 tty_wait_until_sent_from_close()
Message-ID: <20140617125441.67cd5ef4@alan.etchedpixels.co.uk>
In-Reply-To: <8191805.dfI4LbYmWz@wuerfel>
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
	<53A01F02.7000202@hurleysoftware.com>
	<063D6719AE5E284EB5DD2968C1650D6D1725DAF6@AcuExch.aculab.com>
	<8191805.dfI4LbYmWz@wuerfel>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Before the patch, I believe tty_reopen() would return -EIO because
> the TTY_CLOSING flag is set. After the patch, tty_open() blocks
> on tty_lock() before calling tty_reopen(). AFAICT, this is independent
> of O_NONBLOCK.

That would be a bug then. Returning -EIO is fine (if unfriendly). The
O_NONBLOCK can't block in this case though because the port could take a
long time to give up trying to dribble its bits (up to 30 seconds or so)

Alan

