Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965462AbaCUNWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 09:22:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43284 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbaCUNWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 09:22:21 -0400
Message-ID: <1395408140.9455.1.camel@linux-fkkt.site>
Subject: Re: Check if usb device is suspended
From: Oliver Neukum <oneukum@suse.de>
To: Jagdish Gedia <jvgediya@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 21 Mar 2014 14:22:20 +0100
In-Reply-To: <CAOAoqGuiBrg_tYhdNXd3r48YC9KQ5GNm7jrV4ttNiMjNkrCKRA@mail.gmail.com>
References: <CAOAoqGt_Y_weA2FjA8x-NrZS7zj+=Zw-TH5Xv+QUQDJQixmdsw@mail.gmail.com>
	 <Pine.LNX.4.44L0.1403131017430.1292-100000@iolanthe.rowland.org>
	 <CAOAoqGuiBrg_tYhdNXd3r48YC9KQ5GNm7jrV4ttNiMjNkrCKRA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-21 at 17:17 +0530, Jagdish Gedia wrote:
> I want to resume the usb device on some event, so i want to check if
> it is suspended. I think by above method i can check if the device is
> already suspended, but may be i will miss to resume the device if it
> is suspending. Is there any way through which i can check if device is
> suspending?

Just don't do that. If a device needs to be awake for some operation,
call usb_autopm_get(). If the device is already awake, it is a nop
besides keeping the device awake.
Checking is not a sensible strategy.

	Regards
		Oliver


