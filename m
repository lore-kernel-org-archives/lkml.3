Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab3LSPpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:45:45 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55831 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753614Ab3LSPpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:45:43 -0500
Date: Thu, 19 Dec 2013 10:45:42 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Rashika Kheria <rashika.kheria@gmail.com>
cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <josh@joshtriplett.org>
Subject: Re: [PATCH 3/7] drivers: usb: Include appropriate header file in
 hcd.h
In-Reply-To: <026c3f34e6c26d5456940c28a0f33da96064e023.1387439261.git.rashika.kheria@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1312191043280.984-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013, Rashika Kheria wrote:

> Include header file include/linux/usb.h in include/linux/usb/hcd.h
> because structures usb_device, usb_host_config and usb_interface have
> their definitions in include/linux/usb.h.
> 
> This eliminates the following warning in include/linux/usb/hcd.h:
> include/linux/usb/hcd.h:311:44: warning: ‘struct usb_device’ declared inside parameter list [enabled by default]
> include/linux/usb/hcd.h:412:10: warning: ‘struct usb_host_config’ declared inside parameter list [enabled by default]
> include/linux/usb/hcd.h:614:9: warning: ‘struct usb_interface’ declared inside parameter list [enabled by default]

Where does this problem show up?

Any file that include linux/usb/hcd.h should include linux/usb.h first.  
IMO it would be better to fix the source files that don't do the 
includes properly.

Of course, people have varying opinions on this issue.  As far as I 
know, there is no fixed policy in the kernel about nested includes.

Alan Stern

