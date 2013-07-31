Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760559Ab3GaRwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 13:52:38 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41659 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab3GaRwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 13:52:36 -0400
Date: Wed, 31 Jul 2013 18:52:32 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Aaron Lu <aaron.lwe@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [REGRESSION/PATCH] acpi: blacklist win8 OSI for ASUS Zenbok
 Prime UX31A
Message-ID: <20130731175232.GA29987@srcf.ucam.org>
References: <1375125658-1223-1-git-send-email-felipe.contreras@gmail.com>
 <3453253.oZLO1ChPbL@vostro.rjw.lan>
 <CAMP44s02V_FO1BPJZqo6MB9RMknXYdV7AXDqbJzYHpgK1GUuJw@mail.gmail.com>
 <37178266.QXgbv9rq0i@vostro.rjw.lan>
 <CAMP44s2LqiEGtS72FuTjsHUa1MH2kfaYHmcpNKMmAm2LnbFCCQ@mail.gmail.com>
 <20130731051421.GA15766@srcf.ucam.org>
 <CAMP44s2B=nQLnZm7gyYAJZgt_x3KszRZLUC=fom0t9=Eze+smA@mail.gmail.com>
 <20130731140010.GA24560@srcf.ucam.org>
 <CAMP44s1cLou9TMfLS+FHwPM_b3bG5HN1-hzgvhz0fVRCZ8XqWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s1cLou9TMfLS+FHwPM_b3bG5HN1-hzgvhz0fVRCZ8XqWw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 12:46:04PM -0500, Felipe Contreras wrote:

> That doesn't change the fact that you were wrong, and there *is*
> actually a way. The fact that you don't want to go there doesn't mean
> it's not there.

A quirk list will be incomplete, and as such there's no way to guarantee 
whether or not a value of 0 will turn off the backlight. This is why the 
interface doesn't make that guarantee, and why any userspace that 
depends upon that behaviour is behaving incorrectly.

> Here's another: device tree.

There's no functional distinction between device tree and a quirk list 
on x86 - they're both static data sources provided by something other 
than the system firmware. As a result, they will both be incomplete.

> There are ways to provide a consistent backlight interface to user-space.

No, there aren't. What you *can* do is propose to change the ABI 
description for the sysfs backlight interface such that any system where 
0 turns off the backlight is considered buggy, but that won't make those 
systems vanish. A good interface doesn't promise things it can't 
guarantee, so I'd expect that any such proposal would be rejected.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
