Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbaDOIfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:35:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbaDOIfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:35:22 -0400
Message-ID: <1397550919.3307.39.camel@linux-fkkt.site>
Subject: Re: [PATCH] USB: cdc-acm: fix broken runtime suspend
From: Oliver Neukum <oneukum@suse.de>
To: Johan Hovold <jhovold@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Xiao Jin <jin.xiao@intel.com>, david.a.cohen@linux.intel.com,
        yanmin.zhang@intel.com
Date: Tue, 15 Apr 2014 10:35:19 +0200
In-Reply-To: <1397505492-10018-1-git-send-email-jhovold@gmail.com>
References: <20140411093715.GA17522@localhost>
	 <1397505492-10018-1-git-send-email-jhovold@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-14 at 21:58 +0200, Johan Hovold wrote:

> Fix this by implementing a delayed-write queue using urb anchors and
> making sure to discard the queue properly at shutdown.

Looks very good, with one exception: acm_tty_close() must
synchronously resume the device so that the anchor is emptied
before ASYNCB is cleared.

	Regards
		Oliver


