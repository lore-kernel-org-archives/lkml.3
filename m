Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaFRVsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 17:48:06 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34799 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751119AbaFRVsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 17:48:03 -0400
Date: Wed, 18 Jun 2014 22:47:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rob Herring <robherring2@gmail.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
Message-ID: <20140618214752.GL32514@n2100.arm.linux.org.uk>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <CAL_JsqKw-C6uZBU3hccGmdofXcCcUKTV6z7Af6KwYwnZiy3HoQ@mail.gmail.com> <201406182122.29623@pali> <CAL_JsqK5j8PvYfq+tct4RMr63TWDYGfi_TA28k5m4KyG=UuNbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_JsqK5j8PvYfq+tct4RMr63TWDYGfi_TA28k5m4KyG=UuNbg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 03:46:19PM -0500, Rob Herring wrote:
> On Wed, Jun 18, 2014 at 2:22 PM, Pali Rohár <pali.rohar@gmail.com> wrote:
> > Also I still did not know why DT kernel does not report Revision
> > number which is passed by bootloader via atags. Any idea?
> 
> Probably because no one cared until now and revision info for every
> SOC is different. I would like to see revision info set in the DT in a
> standard way and remove the various SOC specific kernel
> implementations.

Except... that's not what it is.  What that revision field was originally
invented for was the Netwinder to indicate the _platform_ revision.

>From what I've seen, almost everyone else sets this to zero in their
boot loaders - it is /very/ rarely used.  However, I think OMAP (ab)uses
it by putting the SoC revision into it at kernel boot time.  That's
not what it is supposed to be used for.

Others have already solved the problem of exporting SoC specific
information, such as SoC name, SoC revision, etc, if only people would
use it - drivers/base/soc.c.  This gives machine, family, soc_id and
SoC revision information in a standard place - it /might/ have been
a good idea if the creation of that also contained documentation for
what was expected in each of the fields, rather than leaving it
open...

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
