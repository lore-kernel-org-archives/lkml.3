Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331AbaGWQIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:08:30 -0400
Received: from cpc2-cwma8-2-0-cust224.7-3.cable.virginm.net ([82.20.154.225]:58858
	"EHLO alan.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758191AbaGWQI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:08:29 -0400
Date: Wed, 23 Jul 2014 17:07:53 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: "xinhui.pan" <xinhuix.pan@intel.com>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Greg KH <gregkh@linuxfoundation.org>, mnipxh <mnipxh@gmail.com>,
        jslaby@suse.cz, linux-kernel@vger.kernel.org,
        yanmin_zhang@linux.intel.com
Subject: Re: [PATCH] tty/tty_io.c: make a check before reuse cdev
Message-ID: <20140723170753.5e2047c5@alan.etchedpixels.co.uk>
In-Reply-To: <53CF7EAC.8010201@intel.com>
References: <53CD0BD4.4050007@gmail.com>
	<20140721153840.GA6802@kroah.com>
	<53CE5097.2000502@intel.com>
	<53CE941B.1030102@hurleysoftware.com>
	<53CF7EAC.8010201@intel.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Very nice solution. We will check if this can cause any risk, both to kernel and user space.
> Using a new tty base to register with new cdevs may give us more chance to wait PROCESS quit/close.
> when total 256 tty used up, what we should do is still in discuss.

At that point you may want to look at how fuser works and create some
kind of policy manager needs to kill problem tasks owning a device.

Or in theory there is no reason nowdays we can't go above 256 devices -
in theory 8)

Alan


