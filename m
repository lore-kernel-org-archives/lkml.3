Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab3EaOs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 10:48:57 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37958 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab3EaOsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 10:48:39 -0400
Date: Fri, 31 May 2013 15:48:26 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Jiri Kosina <jkosina@suse.cz>, Russ Anderson <rja@sgi.com>,
        joeyli <jlee@suse.com>, Matt Fleming <matt@console-pimps.org>,
        matt.fleming@intel.com, linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Message-ID: <20130531144826.GB5850@srcf.ucam.org>
References: <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz>
 <1369880172.17397.11.camel@linux-s257.site>
 <20130530221737.GA11105@sgi.com>
 <alpine.LNX.2.00.1305310023020.30576@pobox.suse.cz>
 <20130531101250.GD30394@gmail.com>
 <alpine.LNX.2.00.1305311259520.30576@pobox.suse.cz>
 <20130531123015.GC17843@nazgul.tnic>
 <20130531124356.GA8212@gmail.com>
 <20130531143425.GA5850@srcf.ucam.org>
 <1370011357.1913.15.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370011357.1913.15.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 07:42:37AM -0700, James Bottomley wrote:
> On Fri, 2013-05-31 at 15:34 +0100, Matthew Garrett wrote:
> > I agree that a revert is probably the right thing to do here, but the 
> > original patch was there to permit a more accurate calculation of the 
> > amount of nvram in use, not to provide additional debug information. 
> > Reverting it is going to differently break a different set of systems
> 
> The only ones that are broken are the Samsung ones.  Samsung claims to
> have fixed their UEFI firmware, so we could refer any problems to them.

No, reverting this gets us back to the old state of refusing any writes 
if more than 50% of the variable store *appears* to be used, regardless 
of whether it's actually used. Which, unfortunately, makes it impossible 
to install Linux on most UEFI machines. In any case, Samsung clearly 
haven't fixed this problem on a pile of machines that have already 
shipped.

> Could we hedge the QueryVariableInfo checks with a test for Samsung in
> the UEFI identity strings?

We could, but apparently some Lenovos also have a similar problem. We 
just don't have the information we need to implement a comprehensive 
blacklist, and if we get it wrong we're back to destroying people's 
hardware.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
