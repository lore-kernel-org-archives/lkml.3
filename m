Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161165AbaDJS5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:57:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37929 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933885AbaDJS5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:57:32 -0400
Date: Thu, 10 Apr 2014 20:57:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: df36ac1bc2a16 ("pstore: Don't allow high traffic options on
 fragile devices")
Message-ID: <20140410185724.GC4704@pd.tnic>
References: <20140410181503.GA4704@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31E2465C@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31E2465C@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 06:34:34PM +0000, Luck, Tony wrote:
> Speed is also a factor ... waiting for flash to update for each
> printk() would mess up timing so much that you might not see the
> problem you are chasing.

Gaah, there's that too. I guess nvram access speeds slower than in the
msec range (I'm looking at my printk timestamps) are no good for us.

> A better EFI trick for this would be "capsules". They live in regular
> RAM and BIOS firmware does stuff with them at warm reset time. Matt
> has been looking at them - but BIOS support for them seems sketchy to
> none right now.

Hmm, I'm wondering whether we could put a bunch of sanity checks into
fwts to run on a box and check needed capsules functionality before
logging to one.

Matt, looks like we have ourselves a new project. :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
