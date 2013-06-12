Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab3FLLXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 07:23:31 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41560 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab3FLLX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 07:23:29 -0400
Date: Wed, 12 Jun 2013 13:23:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
        gustavo@padovan.org, linux-bluetooth@vger.kernel.org
Subject: Re: 3.10-rc: bluetooth disappeared on thinkpad x60 (regression)
Message-ID: <20130612112326.GA4237@amd.pavel.ucw.cz>
References: <20130610092907.GA5487@amd.pavel.ucw.cz>
 <20130610100519.GA9816@x220.ger.corp.intel.com>
 <20130610110423.GA8834@amd.pavel.ucw.cz>
 <20130610115938.GA12892@x220.ger.corp.intel.com>
 <20130610133834.GA4058@amd.pavel.ucw.cz>
 <20130610160723.GA18282@x220.P-661HNU-F1>
 <20130610193746.GA30801@amd.pavel.ucw.cz>
 <20130611072245.GA12463@x220>
 <20130611102025.GA5580@x220>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <20130611102025.GA5580@x220>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 2013-06-11 13:20:25, Johan Hedberg wrote:
> Hi Pavel,
> 
> On Tue, Jun 11, 2013, Johan Hedberg wrote:
> > On Mon, Jun 10, 2013, Pavel Machek wrote:
> > > < HCI Command: Delete Stored Link Key (0x03|0x0012) plen 7
> > >     bdaddr 00:00:00:00:00:00 all 1
> > > > HCI Event: Command Complete (0x0e) plen 4
> > >     Delete Stored Link Key (0x03|0x0012) ncmd 1
> > >     status 0x11 deleted 0
> > >     Error: Unsupported Feature or Parameter Value
> > 
> > Here's the cause of your issue. It's not one of the recently added HCI
> > commands but one that's been around for quite some time. I just checked
> > and it's even there in kernel 3.9, so I'm surprised that you're saying
> > this is a regression since that version. Are you completely sure about
> > it?
> 
> Could you try if the attached patch helps? It modifies the HCI request
> state tracking to allow flagging certain HCI commands as non-critical
> and just ignores their failures.

Yes, it helps.

> If the patch helps, could you still provide a HCI trace (both plain text
> and btsnoop format) of a successful "hciconfig hci0 up"? It might help
> create a simpler patch for this issue.

Thanks,
								Pavel

Here you go (binary dump attached):

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
    status 0x00 name 'amd-0'
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
< HCI Command: Read Page Scan Activity (0x03|0x001b) plen 0
> HCI Event: Command Complete (0x0e) plen 8
    Read Page Scan Activity (0x03|0x001b) ncmd 1
    status 0x00 interval 2048 window 18
< HCI Command: Read Page Scan Type (0x03|0x0046) plen 0
> HCI Event: Command Complete (0x0e) plen 5
    Read Page Scan Type (0x03|0x0046) ncmd 1
    0000: 00 01                                             ..
< HCI Command: Set Event Mask (0x03|0x0001) plen 8
    Mask: 0xfffffbff07180000
> HCI Event: Command Complete (0x0e) plen 4
    Set Event Mask (0x03|0x0001) ncmd 1
    status 0x00
< HCI Command: Read Local Supported Commands (0x04|0x0002) plen 0
> HCI Event: Command Complete (0x0e) plen 68
    Read Local Supported Commands (0x04|0x0002) ncmd 1
    status 0x00
    Commands: ffffffffffff1ffffffffffff30fffff3f
< HCI Command: Write Inquiry Mode (0x03|0x0045) plen 1
    mode 1
> HCI Event: Command Complete (0x0e) plen 4
    Write Inquiry Mode (0x03|0x0045) ncmd 1
    status 0x00
< HCI Command: Read Local Extended Features (0x04|0x0004) plen 1
    page 1
> HCI Event: Command Complete (0x0e) plen 14
    Read Local Extended Features (0x04|0x0004) ncmd 1
    status 0x00 page 1 max 0
    Features: 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
< HCI Command: Write Default Link Policy Settings (0x02|0x000f) plen 2
    policy 0x0f
    Link policy: RSWITCH HOLD SNIFF PARK 
> HCI Event: Command Complete (0x0e) plen 4
    Write Default Link Policy Settings (0x02|0x000f) ncmd 1
    status 0x00
< HCI Command: Write Page Timeout (0x03|0x0018) plen 2
    timeout 8192
> HCI Event: Command Complete (0x0e) plen 4
    Write Page Timeout (0x03|0x0018) ncmd 1
    status 0x00
< HCI Command: Write Default Link Policy Settings (0x02|l Name
(0x03|0x0014) plen 0
> HCI Event: Command Complete (0x0e) plen 2
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

--UlVJffcvxoiEqYs2
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=delme
Content-Transfer-Encoding: base64

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
DvwBFAwAYW1kLTAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAABAAAAAIAAAAA
AOG8pktvkW8BDggAAAAACQAAAAkAAAADAAAAAADhvKZLb5i7BA4GAQ4IAA8AAAAADAAAAAwA
AAACAAAAAADhvKZLb5kvAQEMCP//////HwAAAAAABwAAAAcAAAADAAAAAADhvKZLb6CLBA4E
AQEMAAAAAAUAAAAFAAAAAgAAAAAA4bymS2+hAAFFDAEBAAAABwAAAAcAAAADAAAAAADhvKZL
b6hsBA4EAUUMAAAAAPwAAAD8AAAAAgAAAAAA4bymS2+qGgETDPhhbWQtMAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAcAAAAHAAAAAwAAAAAA4bymS2+4CwQOBAETDAAAAAAFAAAA
BQAAAAIAAAAAAOG8pktvuK8BGgwBAgAAAAcAAAAHAAAAAwAAAAAA4bymS2/D0gQOBAEaDAAA
AAAHAAAABwAAAAIAAAAAAOG8pktvxHYBJAwDDAFKAAAABwAAAAcAAAADAAAAAADhvKZLb8el
BA4EASQMAAAAAAQAAAAEAAAAAgAAAAAA4bymS2/IMAEUDAAAAAD/AAAA/wAAAAMAAAAAAOG8
pktwRJQEDvwBFAwAYW1kLTAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAABAAA
AAIAAAAAAOG8pktwRSIBGQwAAAAACAAAAAgAAAADAAAAAADhvKZLcExuBA4FARkMAAI=

--UlVJffcvxoiEqYs2--
