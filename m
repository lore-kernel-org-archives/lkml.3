Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab3FJThv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 15:37:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41936 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab3FJTht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 15:37:49 -0400
Date: Mon, 10 Jun 2013 21:37:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
        gustavo@padovan.org, linux-bluetooth@vger.kernel.org
Subject: Re: 3.10-rc: bluetooth disappeared on thinkpad x60 (regression)
Message-ID: <20130610193746.GA30801@amd.pavel.ucw.cz>
References: <20130610092907.GA5487@amd.pavel.ucw.cz>
 <20130610100519.GA9816@x220.ger.corp.intel.com>
 <20130610110423.GA8834@amd.pavel.ucw.cz>
 <20130610115938.GA12892@x220.ger.corp.intel.com>
 <20130610133834.GA4058@amd.pavel.ucw.cz>
 <20130610160723.GA18282@x220.P-661HNU-F1>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <20130610160723.GA18282@x220.P-661HNU-F1>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> > I ran hcidump, while I did hciconfig hci0 up on other console.
> > 
> > root@amd:~# hcidump hci0
> > HCI sniffer - Bluetooth packet analyzer ver 1.42
> > device: hci0 snap_len: 1028 filter: 0xffffffff
> > < HCI Command: Reset (0x03|0x0003) plen 0
> > > HCI Event: Command Complete (0x0e) plen 4
> > < HCI Command: Read Local Supported Features (0x04|0x0003) plen 0
> > > HCI Event: Command Complete (0x0e) plen 12
> > < HCI Command: Read Local Version Information (0x04|0x0001) plen 0
> > > HCI Event: Command Complete (0x0e) plen 12
> > < HCI Command: Read BD ADDR (0x04|0x0009) plen 0
> > > HCI Event: Command Complete (0x0e) plen 10
> > < HCI Command: Read Buffer Size (0x04|0x0005) plen 0
> > > HCI Event: Command Complete (0x0e) plen 11
> > < HCI Command: Read Class of Device (0x03|0x0023) plen 0
> > > HCI Event: Command Complete (0x0e) plen 7
> > < HCI Command: Read Local Name (0x03|0x0014) plen 0
> > > HCI Event: Command Complete (0x0e) plen 252
> > < HCI Command: Read Voice Setting (0x03|0x0025) plen 0
> > > HCI Event: Command Complete (0x0e) plen 6
> > < HCI Command: Set Event Filter (0x03|0x0005) plen 1
> > > HCI Event: Command Complete (0x0e) plen 4
> > < HCI Command: Write Connection Accept Timeout (0x03|0x0016) plen 2
> > > HCI Event: Command Complete (0x0e) plen 4
> > < HCI Command: Delete Stored Link Key (0x03|0x0012) plen 7
> > > HCI Event: Command Complete (0x0e) plen 4
> > 
> > Hope this helps,
> 
> It gives a better idea but is still lacking a bit of information since
> hcidump is by default quite restrictive in what it outputs. Could you
> try once more, but this time pass the -X and -V command line switches to
> hcidump. It should make it output the full set of parameters of the HCI
> commands and events. What I'd also ask is if you could make an
> additional binary HCI log in the btsnoop format so that we could analyze
> the log with btmon (which has better decoders than hcidump). You get
> hcidump to do this by passing "-B -w <filename>" as parameters and can
> verify that the produced file is correct by running hcidump -r
> <file>.

Ok, here's text log:

(The keys exchanged are not long-lived, so it is okay to post this
publicly.... right?)

Binary dump is attached. Let me know if you need something more,
								Pavel

root@amd:~# hcidump hci0 -X -V
HCI sniffer - Bluetooth packet analyzer ver 1.42
device: hci0 snap_len: 1028 filter: 0xffffffff
< HCI Command: Reset (0x03|0x0003) plen 0
> HCI Event: Command Complete (0x0e) plen 4
    Reset (0x03|0x0003) ncmd 1
    status 0x00
< HCI Command: Read Local Supported Features (0x04|0x0003) plen 0
> HCI Event: Command Complete (0x0e) plen 12
    Read Local Supported Features (0x04|0x0003) ncmd 1
    status 0x00
    Features: 0xff 0xff 0x8d 0xfe 0x9b 0xf9 0x00 0x80
< HCI Command: Read Local Version Information (0x04|0x0001) plen 0
> HCI Event: Command Complete (0x0e) plen 12
    Read Local Version Information (0x04|0x0001) ncmd 1
    status 0x00
    HCI Version: 2.0 (0x3) HCI Revision: 0x206c
    LMP Version: 2.0 (0x3) LMP Subversion: 0x4132
    Manufacturer: Broadcom Corporation (15)
< HCI Command: Read BD ADDR (0x04|0x0009) plen 0
> HCI Event: Command Complete (0x0e) plen 10
    Read BD ADDR (0x04|0x0009) ncmd 1
    status 0x00 bdaddr 00:16:CE:EC:4D:C2
< HCI Command: Read Buffer Size (0x04|0x0005) plen 0
> HCI Event: Command Complete (0x0e) plen 11
    Read Buffer Size (0x04|0x0005) ncmd 1
    status 0x00
    ACL MTU 1017:8 SCO MTU 64:0
< HCI Command: Read Class of Device (0x03|0x0023) plen 0
> HCI Event: Command Complete (0x0e) plen 7
    Read Class of Device (0x03|0x0023) ncmd 1
    status 0x00 class 0x000000
< HCI Command: Read Local Name (0x03|0x0014) plen 0
> HCI Event: Command Complete (0x0e) plen 252
    Read Local Name (0x03|0x0014) ncmd 1
    status 0x00 name 'IBM Callisto'
< HCI Command: Read Voice Setting (0x03|0x0025) plen 0
> HCI Event: Command Complete (0x0e) plen 6
    Read Voice Setting (0x03|0x0025) ncmd 1
    status 0x00 voice setting 0x0060
< HCI Command: Set Event Filter (0x03|0x0005) plen 1
    type 0 condition 0
    Clear all filters
> HCI Event: Command Complete (0x0e) plen 4
    Set Event Filter (0x03|0x0005) ncmd 1
    status 0x00
< HCI Command: Write Connection Accept Timeout (0x03|0x0016) plen 2
    timeout 32000
> HCI Event: Command Complete (0x0e) plen 4
    Write Connection Accept Timeout (0x03|0x0016) ncmd 1
    status 0x00
< HCI Command: Delete Stored Link Key (0x03|0x0012) plen 7
    bdaddr 00:00:00:00:00:00 all 1
> HCI Event: Command Complete (0x0e) plen 4
    Delete Stored Link Key (0x03|0x0012) ncmd 1
    status 0x11 deleted 0
    Error: Unsupported Feature or Parameter Value


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

--XsQoSWH+UP9D9v3l
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=delme
Content-Transfer-Encoding: base64

YnRzbm9vcAAAAAABAAAD6gAAAAQAAAAEAAAAAgAAAAAA4byE8lm0/QEDDAAAAAAHAAAABwAA
AAMAAAAAAOG8hPJZwzcEDgQBAwwAAAAABAAAAAQAAAACAAAAAADhvITyWcO3AQMQAAAAAA8A
AAAPAAAAAwAAAAAA4byE8lnLAgQODAEDEAD//43+m/kAgAAAAAQAAAAEAAAAAgAAAAAA4byE
8lnLdgEBEAAAAAAPAAAADwAAAAMAAAAAAOG8hPJZ0tQEDgwBARAAA2wgAw8AMkEAAAAEAAAA
BAAAAAIAAAAAAOG8hPJZ01EBCRAAAAAADQAAAA0AAAADAAAAAADhvITyWdqoBA4KAQkQAMJN
7M4WAAAAAAQAAAAEAAAAAgAAAAAA4byE8lnbhQEFEAAAAAAOAAAADgAAAAMAAAAAAOG8hPJZ
4nYEDgsBBRAA+QNACAAAAAAAAAQAAAAEAAAAAgAAAAAA4byE8lni6QEjDAAAAAAKAAAACgAA
AAMAAAAAAOG8hPJZ6jwEDgcBIwwAAAAAAAAABAAAAAQAAAACAAAAAADhvITyWeq7ARQMAAAA
AP8AAAD/AAAAAwAAAAAA4byE8lpnQgQO/AEUDABJQk0gQ2FsbGlzdG8AAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAQAAAAEAAAAAgAAAAAA4byE8lpn0wElDAAAAAAJAAAACQAAAAMAAAAAAOG8
hPJaay8EDgYBJQwAYAAAAAAFAAAABQAAAAIAAAAAAOG8hPJaa7wBBQwBAAAAAAcAAAAHAAAA
AwAAAAAA4byE8lpvFQQOBAEFDAAAAAAGAAAABgAAAAIAAAAAAOG8hPJab54BFgwCAH0AAAAH
AAAABwAAAAMAAAAAAOG8hPJacwEEDgQBFgwAAAAACwAAAAsAAAACAAAAAADhvITyWnOLARIM
BwAAAAAAAAEAAAAHAAAABwAAAAMAAAAAAOG8hPJaduQEDgQBEgwR

--XsQoSWH+UP9D9v3l--
