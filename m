Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbaEXNQj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 09:16:39 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:60403 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750839AbaEXNQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 09:16:38 -0400
Message-ID: <1400937395.22523.55.camel@x220>
Subject: Re: [PATCH] acornscsi: remove linked command support
From: Paul Bolle <pebolle@tiscali.nl>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 24 May 2014 15:16:35 +0200
In-Reply-To: <1400933617.6956.34.camel@dabdike.int.hansenpartnership.com>
References: <1400926433.31526.89.camel@x220> <538075E0.4080001@suse.de>
	 <1400933617.6956.34.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 May 2014 13:16:36.0342 (UTC) FILETIME=[63DC0160:01CF7752]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-05-24 at 16:13 +0400, James Bottomley wrote:
> Wait, no, that's not a good idea.  We leave obsolete drivers to bitrot.
> Particularly we try not to touch them unless we have to because there
> might be a few people still using them and the more we tamper, the
> greater the risk that something gets broken.

Which is also a way to notice whether people still use those obsolete
drivers.

> On that principle, since
> there's no real reason to remove the code,

(Unless one carries the hope that any check, treewide, for a CONFIG_*
macro can be linked to a proper Kconfig symbol.)

> it should stay ... until the
> whole driver bitrots to the extent that we can no-longer compile it.

I've run into this depreciation policy before. With aic7xxx_old (which I
eventually convinced Fedora to disable, a few relases before it was
removed from the tree). With aic94xx (which I also convinced Fedora to
disable). I also tried multiple times to shut up advansys' compile
time[1]. It seems SCSI might risk not to notice their bitrot, because
eventually everybody stops compiling these obsolete drivers, leaving
SCSI without feedback on their state.

Anyhow, SCSI seems to be the only subsystem that uses this subcategory
of not-really-maintained drivers. Other subsystems appear to allow
anything to be fixed, even trivialities, which are what I tend to fix,
and only stop allowing fixes if the drivers involved are going to be
removed anyway. But maybe I just never ran into that category in other
subsystems.

> However, I'll do this if the Maintainer (rmk) acks ... because if it
> breaks he gets to fix it.


Paul Bolle

[1] advansys prints a pointless compile time warning, on purpose.
Clearly no one cares about its "wide board" support, but for some reason
that warning needs to stay in. (Fedora declined to disable that driver.)

