Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab3GHQeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:34:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49510 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751305Ab3GHQd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:33:59 -0400
Date: Mon, 8 Jul 2013 17:33:57 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20130708163357.GA4752@decadent.org.uk>
References: <1373298554.4298.228.camel@chaos.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373298554.4298.228.camel@chaos.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: Suspect loop in dmi_scan_machine()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 05:49:14PM +0200, Jean Delvare wrote:
> Hi Ben,
> 
> I am looking at this commit of yours:
> 
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/firmware/dmi_scan.c?id=79bae42d51a5d498500c890c19ef76df41d2bf59
> 
> and am a little worried about the for loop in dmi_scan_machine()
> (non-EFI case):
[...]

I don't see any of the bugs you describe.  Let me explain what
I probably should have put in a comment:

We want to find a DMI header at [0xf0000, 0xffff0] and possibly an
SMBIOS header 16 bytes before that.  buf contains a copy of the 32
bytes centred at p.  On the first iteration p - 16 is out of range, so
the first 16 bytes of the buffer are filled with zeroes.

Does that address your concerns?  If not then please explain precisely
how this loop can go wrong.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
