Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbaJWLbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:31:24 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:38982 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376AbaJWLav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:30:51 -0400
Date: Thu, 23 Oct 2014 12:30:36 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH -next 11/27] tty: Don't release tty locks for wait queue
 sanity check
Message-ID: <20141023123036.659e8478@alan.etchedpixels.co.uk>
In-Reply-To: <5447EA9F.1070401@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
	<1413491125-20134-12-git-send-email-peter@hurleysoftware.com>
	<20141022162911.432c9bcc@alan.etchedpixels.co.uk>
	<5447EA9F.1070401@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (and -- don't laugh -- explore why printk disables interrupts and prevents
> cpu migration while calling the console drivers. Seems ok to me...)

It disables interrupts so that the chance of the oops getting out is
maximised, it locks down some of the other bits to try and stop
interleaved oopses producing garbage when say a 16 way server goes pop and
all the cpus oops at once.

Not sure about the migration 8)

Alan
