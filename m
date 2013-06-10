Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab3FJLE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:04:27 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40842 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab3FJLE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:04:26 -0400
Date: Mon, 10 Jun 2013 13:04:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
        gustavo@padovan.org, linux-bluetooth@vger.kernel.org
Subject: Re: 3.10-rc: bluetooth disappeared on thinkpad x60 (regression)
Message-ID: <20130610110423.GA8834@amd.pavel.ucw.cz>
References: <20130610092907.GA5487@amd.pavel.ucw.cz>
 <20130610100519.GA9816@x220.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130610100519.GA9816@x220.ger.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > root@amd:~# hciconfig hci0 up
> > Can't init device hci0: Operation not supported (95)
> > root@amd:~# hcitool inq
> > Inquiring ...
> > Inquiry failed.: No such device
> > root@amd:~# 
> 
> Could you take logs of the HCI traffic that happens when you try this.
> You can use the btmon tool from BlueZ for it. Based on a quick look at
> the code it seems like this particular error could only come if one of
> the HCI commands used for device initialization fails.

Where can I get btmon? I tried 

root@amd:~# apt-get install bluez-utils

but it is not there. (Can I just add printk somewhere?)

> The Bluetooth HCI init sequence is constructed using only commands that
> should be expected to work assuming the hardware follows the
> specification, but occasionally we do encounter Bluetooth hardware that
> is broken in one way or another and needs a work around to the sequence.
> E.g. recently we added a couple of extra commands to read some new
> parameters from the hardware, commands that are mandatory for hardware
> beyond a specific version (something we check for), but could be that
> the chip on the X60 doesn't support these.

I don't expect strace is enough?

set_thread_area({entry_number:-1 -> 6, base_addr:0xb7624b20,
limit:1048575, seg_32bit:1, contents:0, read_exec_only:0,
limit_in_pages:1, seg_not_present:0, useable:1}) = 0
mprotect(0xb7766000, 8192, PROT_READ)   = 0
mprotect(0xb77b2000, 4096, PROT_READ)   = 0
munmap(0xb7782000, 76642)               = 0
socket(PF_BLUETOOTH, SOCK_RAW, 1)       = 3
ioctl(3, 0x800448d3, 0xb77cc420)        = 0
ioctl(3, 0x400448c9, 0)                 = -1 EOPNOTSUPP (Operation not
supported)
write(2, "Can't init device hci0: Operatio"..., 53Can't init device
hci0: Operation not supported (95)
) = 53
exit_group(1)                           = ?
root@amd:~# btmon

Thanks,
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
