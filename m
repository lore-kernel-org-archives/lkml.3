Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750825AbaLNRvQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 12:51:16 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:58805 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbaLNRvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 12:51:13 -0500
MIME-Version: 1.0
In-Reply-To: <CAFSKS=PnDa+_2eBk0M7xiE5me-7muo2ddVzhk=gHWMYoXhZtmw@mail.gmail.com>
References: <1418081057-25283-1-git-send-email-george.mccollister@gmail.com>
	<20141210130412.GJ14346@localhost>
	<CAFSKS=PnDa+_2eBk0M7xiE5me-7muo2ddVzhk=gHWMYoXhZtmw@mail.gmail.com>
Date: Sun, 14 Dec 2014 11:51:11 -0600
Message-ID: <CAFSKS=MH0CU=t-TyHgcOun050EBQawkaDXfSN2OoC6MpZKgjmw@mail.gmail.com>
Subject: Re: [PATCH] USB: serial: add nt124 usb to serial driver
From: George McCollister <george.mccollister@gmail.com>
To: Johan Hovold <johan@kernel.org>
Cc: linux-usb@vger.kernel.org, open list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johan,

While working on the tx_empty changes you suggested it occurred to me
that it might not be obvious to others that the firmware doesn't send
a packet with the NT124_CTRL_TXEMPTY flag cleared when it begins
transmitting. The practical implication is that if the driver sets
tx_empty = true when it sees NT124_CTRL_TXEMPTY, tx_empty must be
reset to false somewhere when more data is transmitted. Perhaps I
could add prepare_write_buffer and do it in there before calling
usb_serial_generic_prepare_write_buffer(). Does that sound acceptable?
If so I'll also initialize tx_empty = true in nt124_port_probe.

Regards,
George
