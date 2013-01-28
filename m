Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab3A1PRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:17:35 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:37343 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750906Ab3A1PRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:17:34 -0500
Date: Mon, 28 Jan 2013 10:17:33 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: tony@atomide.com, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 09/30] USB: ehci-omap: Use devm_request_and_ioremap()
In-Reply-To: <1359372631-8180-10-git-send-email-rogerq@ti.com>
Message-ID: <Pine.LNX.4.44L0.1301281013010.1997-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2013, Roger Quadros wrote:

> Make use of devm_request_and_ioremap() and correct comment.

Didn't a big patch come through recently converting all usages of 
devm_request_and_ioremap() to another function (I forget the name) that 
does its own error reporting and returns an ERR_PTR value?

(Checks the mailing list archive...)  Ah, here it is:

	http://marc.info/?l=linux-usb&m=135876311801537&w=2

And the new function is devm_ioremap_resource().  We should avoid 
adding new usages of an old interface.

Alan Stern

