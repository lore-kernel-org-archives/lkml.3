Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448Ab3HGVXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:23:25 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54973 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933337Ab3HGVXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:23:21 -0400
Date: Wed, 7 Aug 2013 22:23:02 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Fish <afish@apple.com>
Cc: Matt Fleming <matt@console-pimps.org>, edk2-devel@lists.sourceforge.net,
        Laszlo Ersek <lersek@redhat.com>, linux-efi@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [edk2] Corrupted EFI region
Message-ID: <20130807212302.GA10905@srcf.ucam.org>
References: <51FFD5B0.9080000@redhat.com>
 <20130805164731.GG31845@pd.tnic>
 <52001896.1030509@redhat.com>
 <20130805220808.GC14067@pd.tnic>
 <20130806141036.GD14891@pd.tnic>
 <520116D1.2010000@redhat.com>
 <20130807151935.GJ17920@pd.tnic>
 <CCFD3CBD-62B0-4046-B96D-18CB1A815F72@apple.com>
 <20130807201908.GG2515@console-pimps.org>
 <D5982201-6DC4-469F-812A-74A8402ADEE9@apple.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D5982201-6DC4-469F-812A-74A8402ADEE9@apple.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 02:10:28PM -0700, Andrew Fish wrote:

> Well the issue I see is I don't think OS X or Windows are doing this. 
> So I'm guessing there is some unique thing beings done on the Linux 
> side and we don't have good tests to catch bugs in the EFI 
> implementations. If the Linux loader hides the bugs and we don't hit 
> them with other operating systems they are never going to get fixed. 
> It would be good if we could track down some of these issues and make 
> a request for some tests that can help catch these issues. The tests 
> would be part of UEFI.org, but since some of us play in both worlds we 
> can forward the known issues to the UEFI test work group.

Linux enables NX before calling SetVirtualAddressMap(). If other OSes 
don't do that, you probably won't see the bug.

> Is it possible to have a switch to turn off the not required behavior 
> (hiding EFI implementation bugs) so that bad platforms could be 
> detected? This would be a good thing to try on platforms at the 
> upcoming UEFI Plugfest hosted by the Linux Foundation and the UEFI 
> Forum, so the bad behavior can be detected and the vendors can fix the 
> issue.

It's behaviour that we already have to work around due to shipping 
hardware exhibiting it, so while we could certainly develop a test, 
Linux is always going to need to include the workaround code.

That being said, some of what we do with the memory map in Linux right 
now is probably unnecessary - we're modifying the memory map because 
that's a convenient place to store the information, rather than because 
the memory map actually needs to be modified. We could do a better job 
of that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
