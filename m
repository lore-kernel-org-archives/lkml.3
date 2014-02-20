Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbaBTUkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 15:40:32 -0500
Received: from relay2.sgi.com ([192.48.179.30]:53220 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753050AbaBTUka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 15:40:30 -0500
Date: Thu, 20 Feb 2014 14:40:29 -0600
From: Russ Anderson <rja@sgi.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minyard@acm.org" <minyard@acm.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
Message-ID: <20140220204028.GJ17949@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <1392740909-2079-1-git-send-email-matthew.garrett@nebula.com> <20140220201458.GA7099@sgi.com> <1392927381.20109.0.camel@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392927381.20109.0.camel@x230>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 08:16:22PM +0000, Matthew Garrett wrote:
> On Thu, 2014-02-20 at 14:14 -0600, Russ Anderson wrote:
> 
> > The distro that added this change created all sorts of support
> > problems.  Problems include kipmi0 spinning at 100% of cpu
> > (creating a performance hit) and long boot delays (as the
> > kernel tries to talk to a BMC that will never respond).
> > It has been a big mess.
> 
> Why is the BMC not responding? Why is kipmi0 at 100%? Why are we not
> fixing those bugs?

Why build a driver into the kernel?  The reason ipmi_si is 
a driver is so systems that want it can load it and systems
that do not want it do not have to load it.  Plus you can
stop/start modules without rebooting.  You can change module
parameters without rebooting.

There are any number of reasons why a BMC may not respond.
BMCs are notorious for being flakey, with different types
of BMCs that may or may not be reliable.  You do not want
to make the kernel boot dependent on an unreliable component.

This is also a problem for systems with functional BMCs.  Our
large cluster systems do all IPMI traffic (monitoring) through
a system controller back door.  We do not want the kernel
doing IPMI commands on those systems.   On those systems we
simply do not load the ipmi_si module.  Building ipmi_si
into the kernel means adding kernel boot line options to
turn ipmi_si back off again.


-- 
Russ Anderson,  Kernel and Performance Software Team Manager
SGI - Silicon Graphics Inc          rja@sgi.com
