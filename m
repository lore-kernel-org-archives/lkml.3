Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720AbaFKRa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:30:26 -0400
Received: from relay2.sgi.com ([192.48.180.65]:42735 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932778AbaFKRaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:30:24 -0400
Date: Wed, 11 Jun 2014 12:30:22 -0500
From: Alex Thorlton <athorlton@sgi.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Alex Thorlton <athorlton@sgi.com>, Linux EFI <linux-efi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Russ Anderson <rja@sgi.com>
Subject: Re: [RFC] Best place/method to determine BIOS version?
Message-ID: <20140611173022.GD3275@sgi.com>
References: <20140609200017.GD2700@sgi.com>
 <20140611085548.GB26290@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611085548.GB26290@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 09:55:48AM +0100, Matt Fleming wrote:
> Can't you use either early_ioremap() or ioremap() (depending on when you
> want to access the physical address), perhaps coupled with
> efi_call_phys()?

I had actually tried that exact approach, but I think the problem is
that I need to remap both the function code, and the data that it needs
to access, and the pointers get clobbered in that process.  The pointers
work fine in direct physical mode, and they work fine after being mapped
into the EFI page table in virtual mode, but I think there's some magic
in there that helps fix them up when set_virtual_address_map is called,
which isn't getting done when I try to remap manually.

I'll look into this approach a bit more to be absolutely sure that it
won't work, but I hadn't had any luck so far.

- Alex
