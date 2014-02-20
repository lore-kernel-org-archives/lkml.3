Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445AbaBTX7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:59:10 -0500
Received: from relay1.sgi.com ([192.48.179.29]:40634 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756432AbaBTX7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:59:06 -0500
Date: Thu, 20 Feb 2014 17:59:05 -0600
From: Russ Anderson <rja@sgi.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minyard@acm.org" <minyard@acm.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, rja@sgi.com
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
Message-ID: <20140220235904.GZ17949@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20140220204028.GJ17949@sgi.com> <1392929163.20109.5.camel@x230> <20140220205901.GM17949@sgi.com> <1392930047.20109.6.camel@x230> <20140220212854.GO17949@sgi.com> <1392932363.20109.11.camel@x230> <20140220220656.GT17949@sgi.com> <1392935204.20109.17.camel@x230> <20140220224529.GV17949@sgi.com> <1392937781.20109.24.camel@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392937781.20109.24.camel@x230>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 11:09:42PM +0000, Matthew Garrett wrote:
> On Thu, 2014-02-20 at 16:45 -0600, Russ Anderson wrote:
> > On Thu, Feb 20, 2014 at 10:26:45PM +0000, Matthew Garrett wrote:
> 
> > > Because I'm trying to ensure that the default behaviour of the kernel is
> > > to *work*. Defaulting to having IPMI be modular means that the default
> > > behaviour of the kernel, as far as the ACPI spec goes, is to be broken.
> > 
> > The ACPI spec requires IPMI functionality before a module loads at
> > boot time?  And the kernel is *broken* if it does not support ACIP IPMI
> > functionality before module load time?  Really?
> 
> There's no mechanism to ensure that IPMI support will be loaded before
> ACPI calls attempt to access IPMI operation regions. Really.

And no mechanism can be added to ensure that ACPI call are
not attempted before IPMI is initialized?  A flag or lock
or exported symbol indicating IPMI support is ready.

> > > ACPI 4.0 includes support for IPMI operation regions. Modular IPMI means
> > > that the kernel will spend a significant amount of time (potentially
> > > until a user manually loads a driver) failing to implement part of the
> > > IPMI specification. That's a problem, and the correct fix is to ensure
> > > that the kernel always implements IPMI support.
> > 
> > The ACPI spec says ipmi_si cannot be a driver?  Really?
> > What is the real problem you are trying to solve?
> 
> The most straightforward case is that of an ACPI power meter.

So it is just a matter of making sure ipmi_si modules loads before
the ACPI power meter module loads, right?  module dependency issue.

>                                                                Several
> vendors implement this with an IPMI operation region. Calling any of the
> power meter functions will trigger access to that IPMI operation region,
> which will fail. This may result in driver initialisation failing. There
> is no express dependency between the power meter driver and ipmi_si,
> because the spec envisages IPMI support as basic kernel functionality.
> It's meant to be there before you start loading any other drivers.

The spec "envisages"?  I get there is a dependency, that IPMI driver
needs to be loaded before ACIP power meter.  This isn't the first
case of a driver being dependent on another driver.  That doesn't
mean IPMI driver must be built into the kernel.

> > > Now, you've described some other problems. I don't disagree that those
> > > are problems. The correct thing for us to do with those problems is to
> > > fix them, not to simply change the kernel defaults such that it's
> > > possible for users to choose between two differently broken states. I'm
> > > absolutely willing to help, as long as you're willing to put some
> > > reasonable amount of effort into describing them.
> > 
> > How about ACPI IPMI functionality starts when the ipmi_si
> > module loads at boot time.  
> 
> I've repeatedly asked for you to provide detailed descriptions of the
> problems you've seen because I have a genuine interest in fixing them.
> If you're just going to childishly refuse then this discussion is
> pointless. 

The distro cases I would point you at are marked private. 
And you do not have access to our internal support system.
A simple google search for "kipmi0" shows a lot of reports of
high cpu utilization.  

And I'm old enough to appreciate being called childishly.  :-)

-- 
Russ Anderson,  Kernel and Performance Software Team Manager
SGI - Silicon Graphics Inc          rja@sgi.com
