Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab3JYQsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 12:48:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab3JYQsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 12:48:10 -0400
Message-ID: <1382719652.2445.1.camel@adam.happyassassin.net>
Authentication-Results: mail.happyassassin.net; dmarc=none header.from=redhat.com
Subject: Re: [PATCH] x86/ACPI: Make Sony Vaio Z1 series to use "reboot=pci"
 default
From: Adam Williamson <awilliam@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: tianyu.lan@intel.com, Matthew Garrett <mjg@redhat.com>, hpa@zytor.com,
        x86@kernel.org, holt@sgi.com, davej@fedoraproject.org, lenb@kernel.org,
        rjw@rjwysocki.net, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 25 Oct 2013 09:47:32 -0700
In-Reply-To: <20131025105352.GA5419@gmail.com>
References: <1382597377-26797-1-git-send-email-tianyu.lan@intel.com>
	 <20131025105352.GA5419@gmail.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-25 at 12:53 +0200, Ingo Molnar wrote:
> * tianyu.lan@intel.com <tianyu.lan@intel.com> wrote:
> 
> > From: Lan Tianyu <tianyu.lan@intel.com>
> > 
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
> > 
> > diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> > index 7e920bf..083ade7 100644
> > --- a/arch/x86/kernel/reboot.c
> > +++ b/arch/x86/kernel/reboot.c
> > @@ -382,6 +382,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
> >  			DMI_MATCH(DMI_PRODUCT_NAME, "C6100"),
> >  		},
> >  	},
> > +	{	/* Handle problems with rebooting on Sony Vaio Z1 series*/
> > +		.callback = set_pci_reboot,
> > +		.ident = "Sony Vaio Z1",
> > +		.matches = {
> > +		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
> > +		DMI_MATCH(DMI_PRODUCT_NAME, "VPCZ1"),
> > +		},
> > +	},
> 
> This is becoming somewhat endemic - do we know _why_ the ACPI reboot 
> method does not work?

I don't, but one comment I could add is that reboot _used_ to work okay
on the Z1. And I _think_ it's worked OK since the April 2011 commit you
mention (so the introduction of that didn't break it), but I can't
absolutely swear to it.

(And yes, of course, reboot from stock-installed, fully-updated Windows
- IIRC, Win7 - on the same system works OK.)
-- 
Adam Williamson
Fedora QA Community Monkey
IRC: adamw | Twitter: AdamW_Fedora | XMPP: adamw AT happyassassin . net
http://www.happyassassin.net

