Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237AbaBUQyF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:54:05 -0500
Received: from relay2.sgi.com ([192.48.179.30]:53818 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933206AbaBUQyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:54:01 -0500
Date: Fri, 21 Feb 2014 10:53:59 -0600
From: Russ Anderson <rja@sgi.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minyard@acm.org" <minyard@acm.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, rja@sgi.com
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
Message-ID: <20140221165354.GO16114@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20140220205901.GM17949@sgi.com> <1392930047.20109.6.camel@x230> <20140220212854.GO17949@sgi.com> <1392932363.20109.11.camel@x230> <20140220220656.GT17949@sgi.com> <1392935204.20109.17.camel@x230> <20140220224529.GV17949@sgi.com> <1392937781.20109.24.camel@x230> <20140220235904.GZ17949@sgi.com> <1392941592.20109.36.camel@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392941592.20109.36.camel@x230>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 12:13:13AM +0000, Matthew Garrett wrote:
> On Thu, 2014-02-20 at 17:59 -0600, Russ Anderson wrote:
> > On Thu, Feb 20, 2014 at 11:09:42PM +0000, Matthew Garrett wrote:
> > > On Thu, 2014-02-20 at 16:45 -0600, Russ Anderson wrote:
> > > > 
> > > > The ACPI spec requires IPMI functionality before a module loads at
> > > > boot time?  And the kernel is *broken* if it does not support ACIP IPMI
> > > > functionality before module load time?  Really?
> > > 
> > > There's no mechanism to ensure that IPMI support will be loaded before
> > > ACPI calls attempt to access IPMI operation regions. Really.
> > 
> > And no mechanism can be added to ensure that ACPI call are
> > not attempted before IPMI is initialized?  A flag or lock
> > or exported symbol indicating IPMI support is ready.
> 
> ACPI functions are a black box to drivers. You make an ACPI call, the
> AML code does something. We could block there, but what's the driver
> supposed to do at that point? The core could call out to a module
> loader, but if the driver is built in and IPMI isn't then you'll end up
> with a 60 second pause in boot and a driver that doesn't work. 

When you say "if the driver is built in" which driver are you
talking about?  I thought the issue was making sure ipmi_si 
driver was loaded before power meter driver.



> > > > > ACPI 4.0 includes support for IPMI operation regions. Modular IPMI means
> > > > > that the kernel will spend a significant amount of time (potentially
> > > > > until a user manually loads a driver) failing to implement part of the
> > > > > IPMI specification. That's a problem, and the correct fix is to ensure
> > > > > that the kernel always implements IPMI support.
> > > > 
> > > > The ACPI spec says ipmi_si cannot be a driver?  Really?
> > > > What is the real problem you are trying to solve?
> > > 
> > > The most straightforward case is that of an ACPI power meter.
> > 
> > So it is just a matter of making sure ipmi_si modules loads before
> > the ACPI power meter module loads, right?  module dependency issue.
> 
> No, because the power meter driver has no way of knowing that a vendor
> has implemented this interface via IPMI. *Any* ACPI entry point could
> theoretically reference IPMI code, even the _INI method that's called
> during ACPI core init. If it does, and if you don't have built-in ACPI
> support, you'd fail ACPI initialisation and things would go downhill
> from there.

Again, it sounds like as long as ipmi_si driver is loaded before
power meter driver, power meter driver is fine.



-- 
Russ Anderson,  Kernel and Performance Software Team Manager
SGI - Silicon Graphics Inc          rja@sgi.com
