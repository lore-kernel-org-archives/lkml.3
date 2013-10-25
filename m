Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab3JYMoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 08:44:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab3JYMoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 08:44:30 -0400
Date: Fri, 25 Oct 2013 08:44:02 -0400
From: Dave Jones <davej@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: tianyu.lan@intel.com, Matthew Garrett <mjg@redhat.com>, hpa@zytor.com,
        x86@kernel.org, holt@sgi.com, davej@fedoraproject.org, lenb@kernel.org,
        rjw@rjwysocki.net, awilliam@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/ACPI: Make Sony Vaio Z1 series to use "reboot=pci"
 default
Message-ID: <20131025124402.GA7089@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ingo Molnar <mingo@kernel.org>, tianyu.lan@intel.com,
	Matthew Garrett <mjg@redhat.com>, hpa@zytor.com, x86@kernel.org,
	holt@sgi.com, davej@fedoraproject.org, lenb@kernel.org,
	rjw@rjwysocki.net, awilliam@redhat.com, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <1382597377-26797-1-git-send-email-tianyu.lan@intel.com>
 <20131025105352.GA5419@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131025105352.GA5419@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 12:53:52PM +0200, Ingo Molnar wrote:

 > > Sony Vaio Z1 series require "reboot=pci" for reboot and power off.
 > > This patch is to add them machines to quirk table and set pci reboot
 > > default.
 > > 
 > > Reference: https://bugzilla.kernel.org/show_bug.cgi?id=61721
 > > Reported-and-tested-by: Adam Williamson <awilliam@redhat.com>
 > > Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
 > > ---
 > >  arch/x86/kernel/reboot.c |    8 ++++++++
 > >  1 file changed, 8 insertions(+)
 > 
 > This is becoming somewhat endemic - do we know _why_ the ACPI reboot 
 > method does not work?
 > 
 > We reworked the x86 reboot sequence 2.5 years agom, in:
 > 
 >  commit 660e34cebf0a11d54f2d5dd8838607452355f321
 >  Author: Matthew Garrett <mjg@redhat.com>
 >  Date:   Mon Apr 4 13:55:05 2011 -0400
 > 
 >     x86: Reorder reboot method preferences
 >     [...]
 > 
 > Do we know why reboot apparently works quickly enough on Windows on 
 > this laptop, but not under Linux? Does Windows use the ACPI reboot 
 > method? If yes, does it use a different pattern?
 > 
 > Is it all perhaps virtualization or IRQ routing related?
 > 
 > I.e. we really need a real analysis here, not just a quirk!

I have a few machines at home that have the same problem.
There does seem to be a number of vendor wide issues here. Pretty much
every vaio and every Dell seems to need working around.

I'd point at the acpi dumps, but they're currently switched off and not
responding to wake-on-lan for some reason.
I'll send them when I get back from kernel summit.

	Dave

