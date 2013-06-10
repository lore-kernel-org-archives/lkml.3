Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab3FJQHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 12:07:34 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:64010 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab3FJQHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 12:07:32 -0400
Date: Mon, 10 Jun 2013 19:07:23 +0300
From: Johan Hedberg <johan.hedberg@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
        gustavo@padovan.org, linux-bluetooth@vger.kernel.org
Subject: Re: 3.10-rc: bluetooth disappeared on thinkpad x60 (regression)
Message-ID: <20130610160723.GA18282@x220.P-661HNU-F1>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
	gustavo@padovan.org, linux-bluetooth@vger.kernel.org
References: <20130610092907.GA5487@amd.pavel.ucw.cz>
 <20130610100519.GA9816@x220.ger.corp.intel.com>
 <20130610110423.GA8834@amd.pavel.ucw.cz>
 <20130610115938.GA12892@x220.ger.corp.intel.com>
 <20130610133834.GA4058@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130610133834.GA4058@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Mon, Jun 10, 2013, Pavel Machek wrote:
> I ran hcidump, while I did hciconfig hci0 up on other console.
> 
> root@amd:~# hcidump hci0
> HCI sniffer - Bluetooth packet analyzer ver 1.42
> device: hci0 snap_len: 1028 filter: 0xffffffff
> < HCI Command: Reset (0x03|0x0003) plen 0
> > HCI Event: Command Complete (0x0e) plen 4
> < HCI Command: Read Local Supported Features (0x04|0x0003) plen 0
> > HCI Event: Command Complete (0x0e) plen 12
> < HCI Command: Read Local Version Information (0x04|0x0001) plen 0
> > HCI Event: Command Complete (0x0e) plen 12
> < HCI Command: Read BD ADDR (0x04|0x0009) plen 0
> > HCI Event: Command Complete (0x0e) plen 10
> < HCI Command: Read Buffer Size (0x04|0x0005) plen 0
> > HCI Event: Command Complete (0x0e) plen 11
> < HCI Command: Read Class of Device (0x03|0x0023) plen 0
> > HCI Event: Command Complete (0x0e) plen 7
> < HCI Command: Read Local Name (0x03|0x0014) plen 0
> > HCI Event: Command Complete (0x0e) plen 252
> < HCI Command: Read Voice Setting (0x03|0x0025) plen 0
> > HCI Event: Command Complete (0x0e) plen 6
> < HCI Command: Set Event Filter (0x03|0x0005) plen 1
> > HCI Event: Command Complete (0x0e) plen 4
> < HCI Command: Write Connection Accept Timeout (0x03|0x0016) plen 2
> > HCI Event: Command Complete (0x0e) plen 4
> < HCI Command: Delete Stored Link Key (0x03|0x0012) plen 7
> > HCI Event: Command Complete (0x0e) plen 4
> 
> Hope this helps,

It gives a better idea but is still lacking a bit of information since
hcidump is by default quite restrictive in what it outputs. Could you
try once more, but this time pass the -X and -V command line switches to
hcidump. It should make it output the full set of parameters of the HCI
commands and events. What I'd also ask is if you could make an
additional binary HCI log in the btsnoop format so that we could analyze
the log with btmon (which has better decoders than hcidump). You get
hcidump to do this by passing "-B -w <filename>" as parameters and can
verify that the produced file is correct by running hcidump -r <file>.

Johan
