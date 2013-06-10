Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab3FJNii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:38:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51197 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab3FJNih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:38:37 -0400
Date: Mon, 10 Jun 2013 15:38:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
        gustavo@padovan.org, linux-bluetooth@vger.kernel.org
Subject: Re: 3.10-rc: bluetooth disappeared on thinkpad x60 (regression)
Message-ID: <20130610133834.GA4058@amd.pavel.ucw.cz>
References: <20130610092907.GA5487@amd.pavel.ucw.cz>
 <20130610100519.GA9816@x220.ger.corp.intel.com>
 <20130610110423.GA8834@amd.pavel.ucw.cz>
 <20130610115938.GA12892@x220.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130610115938.GA12892@x220.ger.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > (Can I just add printk somewhere?)
> 
> If you want, the Bluetooth subsystem does support the dynamic debug
> feature, so you could enable logs for hci_core.c and hci_event.c.
> However, this will likely still not be enough and the HCI logs would
> anyway be needed. One thing to note is that btmon is a quite new tool
> which may not yet be packaged by your distro (it appeared in BlueZ 5,
> released 6 months ago). An alternative which should work too is hcidump,
> probably packed in a bluez-hcidump package on your distro.

hcidump. Sounds good, I can do hcidump :-).

I ran hcidump, while I did hciconfig hci0 up on other console.

root@amd:~# hcidump hci0
HCI sniffer - Bluetooth packet analyzer ver 1.42
device: hci0 snap_len: 1028 filter: 0xffffffff
< HCI Command: Reset (0x03|0x0003) plen 0
> HCI Event: Command Complete (0x0e) plen 4
< HCI Command: Read Local Supported Features (0x04|0x0003) plen 0
> HCI Event: Command Complete (0x0e) plen 12
< HCI Command: Read Local Version Information (0x04|0x0001) plen 0
> HCI Event: Command Complete (0x0e) plen 12
< HCI Command: Read BD ADDR (0x04|0x0009) plen 0
> HCI Event: Command Complete (0x0e) plen 10
< HCI Command: Read Buffer Size (0x04|0x0005) plen 0
> HCI Event: Command Complete (0x0e) plen 11
< HCI Command: Read Class of Device (0x03|0x0023) plen 0
> HCI Event: Command Complete (0x0e) plen 7
< HCI Command: Read Local Name (0x03|0x0014) plen 0
> HCI Event: Command Complete (0x0e) plen 252
< HCI Command: Read Voice Setting (0x03|0x0025) plen 0
> HCI Event: Command Complete (0x0e) plen 6
< HCI Command: Set Event Filter (0x03|0x0005) plen 1
> HCI Event: Command Complete (0x0e) plen 4
< HCI Command: Write Connection Accept Timeout (0x03|0x0016) plen 2
> HCI Event: Command Complete (0x0e) plen 4
< HCI Command: Delete Stored Link Key (0x03|0x0012) plen 7
> HCI Event: Command Complete (0x0e) plen 4

Now I turned off the bluetooth via hw switch (it disappeared from
lsusb), turned it on, and same procedure:

root@amd:~# hcidump hci0
HCI sniffer - Bluetooth packet analyzer ver 1.42
device: hci0 snap_len: 1028 filter: 0xffffffff
< HCI Command: Reset (0x03|0x0003) plen 0
> HCI Event: Command Complete (0x0e) plen 4
< HCI Command: Read Local Supported Features (0x04|0x0003) plen 0
> HCI Event: Command Complete (0x0e) plen 12
< HCI Command: Read Local Version Information (0x04|0x0001) plen 0
> HCI Event: Command Complete (0x0e) plen 12
< HCI Command: Read BD ADDR (0x04|0x0009) plen 0
> HCI Event: Command Complete (0x0e) plen 10
< HCI Command: Read Buffer Size (0x04|0x0005) plen 0
> HCI Event: Command Complete (0x0e) plen 11
< HCI Command: Read Class of Device (0x03|0x0023) plen 0
> HCI Event: Command Complete (0x0e) plen 7
< HCI Command: Read Local Name (0x03|0x0014) plen 0
> HCI Event: Command Complete (0x0e) plen 252
< HCI Command: Read Voice Setting (0x03|0x0025) plen 0
> HCI Event: Command Complete (0x0e) plen 6
< HCI Command: Set Event Filter (0x03|0x0005) plen 1
> HCI Event: Command Complete (0x0e) plen 4
< HCI Command: Write Connection Accept Timeout (0x03|0x0016) plen 2
> HCI Event: Command Complete (0x0e) plen 4
< HCI Command: Delete Stored Link Key (0x03|0x0012) plen 7
> HCI Event: Command Complete (0x0e) plen 4

Hope this helps,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
