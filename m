Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762182Ab3DBTcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 15:32:45 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42008 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761551Ab3DBTcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 15:32:43 -0400
Date: Tue, 2 Apr 2013 21:32:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Joerg Roedel <joro@8bytes.org>
Cc: suravee.suthikulpanit@amd.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] iommu/amd: Add logic to decode AMD IOMMU event flag
Message-ID: <20130402193240.GF17675@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Joerg Roedel <joro@8bytes.org>, suravee.suthikulpanit@amd.com,
	iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1364428283-2548-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20130402143335.GB15687@8bytes.org>
 <20130402144037.GE5488@pd.tnic>
 <20130402150302.GF15687@8bytes.org>
 <20130402152956.GE4391@pd.tnic>
 <20130402160400.GP30540@8bytes.org>
 <20130402161757.GC17519@pd.tnic>
 <20130402163318.GS30540@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130402163318.GS30540@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 06:33:18PM +0200, Joerg Roedel wrote:
> I can't find out in the driver whether the fix works or not. It will
> be noticed later when the x86 code tries to setup the timers and finds
> out that they don't work, which causes a kernel panic.
>
> Okay, in theory I could implement a feedback loop between timer-setup
> and intremap code and try fixups until it works. But that seems not to
> be worth it to work around a buggy BIOS.

Yeah, same here. It's not like we really need intremap to work - we're
only trying to fix the annoying error message currently. :-)

> What I actually thought about was providing an IVRS-override on the
> kernel command line. So that you can specify the IOAPIC_ID->DEVID
> mapping there and make it work this way. What do you think?

I guess that is workable. I can imagine people wanting this if they want
to do the intremap thing on such b0rked BIOSen. So how do I specify this
IOAPIC_ID->DEVID mapping on the cmdline exactly?

> > And yes, I'm very sceptical about having a WARN_ON and it starts
> > screaming on machines all over the place. Good luck explaining to
> > people that you actually wanted to prod BIOS vendors to fix their
> > monkey-on-crack code but they weren't listening in the first place.
> 
> Yeah, that's my fear too. So we leave it better as it is...

Hohumm.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
