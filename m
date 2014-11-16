Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbaKPSUQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 13:20:16 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:55621 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbaKPSUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 13:20:15 -0500
X-Originating-IP: 50.43.41.112
Date: Sun, 16 Nov 2014 10:20:07 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Pieter Smith <pieter@boesman.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 51/56] drivers/char/mem: support compiling out splice
Message-ID: <20141116182007.GA5032@thin>
References: <1415913813-362-1-git-send-email-pieter@boesman.nl>
 <1415913813-362-52-git-send-email-pieter@boesman.nl>
 <20141113220911.GA546@kroah.com>
 <CAPho-_JJGy0cwBVfWKL1Gt9ZQZM+Odo7W05bKQ2JLO+TM-ABJA@mail.gmail.com>
 <20141113223150.GB30412@cloud>
 <20141113233416.GC7678@kroah.com>
 <20141114001948.GA30946@cloud>
 <20141114032722.GA31174@kroah.com>
 <CAPho-_KUc-+c=X6xtLTD2F-o4qi+YpYdnw6F1cx4kniezfs7aw@mail.gmail.com>
 <CAPho-_LCj7bxJ2EvuZtBZXD1buH1V+nKEiobTJUATYmGYVRWcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPho-_LCj7bxJ2EvuZtBZXD1buH1V+nKEiobTJUATYmGYVRWcA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Please don't top-post.]

On Sun, Nov 16, 2014 at 01:18:27PM +0100, Pieter Smith wrote:
> I had a look at the numbers (see below): For a tinyconfig kernel, savings
> outside fs/splice.c are negligible. With the addition of networking
> however, net/core and net/ipv4 can be squeezed for usable savings.
> 
> Should I leave networking (and the rest) until we can come up with a
> non-icky approach outside fs/splice.c?
>
> *THE NUMBERS*
> 
> Given a tinyconfig, fs/splice.c can free up 8.2K (3.5K + 4.7K) with
> CONFIG_SYSCALL_SPLICE. The rest are not worth the effort:
>   fs/splice:
>     syscalls only: add/remove: 0/16 grow/shrink: 2/5 up/down: 114/-3693
> (-3579)
>     the remainder: add/remove: 0/24 grow/shrink: 0/4 up/down: 0/-4824
> (-4824)

Nice!

Go ahead and submit the patches for that portion, and the rest can wait
until we get compiler support for omitting structure fields.

- Josh Triplett
