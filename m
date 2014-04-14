Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbaDNMyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 08:54:01 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42900 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915AbaDNMx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 08:53:56 -0400
Date: Mon, 14 Apr 2014 13:53:33 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Johan Hovold <jhovold@gmail.com>
Cc: Oliver Neukum <oneukum@suse.de>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>, Xiao Jin <jin.xiao@intel.com>,
        david.a.cohen@linux.intel.com, yanmin.zhang@intel.com
Subject: Re: [RFC 1/2] n_tty: fix dropped output characters
Message-ID: <20140414135333.1057aac8@alan.etchedpixels.co.uk>
In-Reply-To: <1397209285-15471-1-git-send-email-jhovold@gmail.com>
References: <20140411093715.GA17522@localhost>
	<1397209285-15471-1-git-send-email-jhovold@gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2014 11:41:24 +0200
Johan Hovold <jhovold@gmail.com> wrote:

> Fix characters being dropped by n_tty_write() due to a failure to
> check the return value of tty_put_char() in do_output_char().
> 
> Characters are currently being dropped by write if a tty driver claims
> to have write room available, but still fails to buffer any data

Your driver is buggy. If you advertise a buffer you must honour it and
neither shrink nor revoke it. 

For an URB based device you almost certainly want internal buffering so
you can do proper packetisation. USB serial these days gets it right - see
drivers/usb/serial/generic.c for a fairly simple kfifo based approach.
Whether applying it to cdc_acm would make sense I don't know but it looks
like it might be simpler over-all than the current arrangement.

Alan
