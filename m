Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478Ab3FMIpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 04:45:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57302 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758463Ab3FMIpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 04:45:51 -0400
Date: Thu, 13 Jun 2013 10:45:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
        gustavo@padovan.org, linux-bluetooth@vger.kernel.org
Subject: Re: 3.10-rc: bluetooth disappeared on thinkpad x60 (regression)
Message-ID: <20130613084548.GB3651@amd.pavel.ucw.cz>
References: <20130610110423.GA8834@amd.pavel.ucw.cz>
 <20130610115938.GA12892@x220.ger.corp.intel.com>
 <20130610133834.GA4058@amd.pavel.ucw.cz>
 <20130610160723.GA18282@x220.P-661HNU-F1>
 <20130610193746.GA30801@amd.pavel.ucw.cz>
 <20130611072245.GA12463@x220>
 <20130611102025.GA5580@x220>
 <20130612112326.GA4237@amd.pavel.ucw.cz>
 <20130613072327.GA12951@x220>
 <20130613080442.GA14677@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613080442.GA14677@x220>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2013-06-13 11:04:42, Johan Hedberg wrote:
> Hi Pavel,
> 
> On Thu, Jun 13, 2013, Johan Hedberg wrote:
> > On Wed, Jun 12, 2013, Pavel Machek wrote:
> > > < HCI Command: Read Local Supported Commands (0x04|0x0002) plen 0
> > > > HCI Event: Command Complete (0x0e) plen 68
> > >     Read Local Supported Commands (0x04|0x0002) ncmd 1
> > >     status 0x00
> > >     Commands: ffffffffffff1ffffffffffff30fffff3f
> > 
> > As I suspected, even though the Delete Stored Link Key command is
> > mandatory from Bluetooth version 1.1 onwards (this controller supports
> > 2.0) this controller doesn't have it mentioned in its supported commands
> > response (counting from 0 it should be bit 7 of octet 6). Therefore, it
> > might be possible to just move sending of this problematic command to
> > after receiving the supported commands response and making it
> > conditional to having its respective bit set in the mask. I'll be
> > sending another patch proposal soon.
> 
> I just sent a patch to linux-bluetooth for this. It would be nice if you
> could revert the previous patch, apply this one instead (also attached
> to this email) and let us know if it works fine.

Patch works for me, thanks!

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
