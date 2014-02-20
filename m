Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbaBTWpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 17:45:33 -0500
Received: from relay3.sgi.com ([192.48.152.1]:36490 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751522AbaBTWpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 17:45:31 -0500
Date: Thu, 20 Feb 2014 16:45:29 -0600
From: Russ Anderson <rja@sgi.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minyard@acm.org" <minyard@acm.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, rja@sgi.com
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
Message-ID: <20140220224529.GV17949@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20140220201458.GA7099@sgi.com> <1392927381.20109.0.camel@x230> <20140220204028.GJ17949@sgi.com> <1392929163.20109.5.camel@x230> <20140220205901.GM17949@sgi.com> <1392930047.20109.6.camel@x230> <20140220212854.GO17949@sgi.com> <1392932363.20109.11.camel@x230> <20140220220656.GT17949@sgi.com> <1392935204.20109.17.camel@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392935204.20109.17.camel@x230>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 10:26:45PM +0000, Matthew Garrett wrote:
> On Thu, 2014-02-20 at 16:06 -0600, Russ Anderson wrote:
> > On Thu, Feb 20, 2014 at 09:39:23PM +0000, Matthew Garrett wrote:
> > > On Thu, 2014-02-20 at 15:28 -0600, Russ Anderson wrote:
> > > 
> > > > For some customers _any_ amount is significant, especially
> > > > on large clustered systems where the amount is multiplied
> > > > by tens or hundreds of thousands of nodes.
> > > > 
> > > > You many not think wasting their cpu cycles is important, but they do.
> > > 
> > > Then they should be running locally built kernels in order to ensure
> > 
> > Why don't YOU run a locally built kernel?
> 
> Because I'm trying to ensure that the default behaviour of the kernel is
> to *work*. Defaulting to having IPMI be modular means that the default
> behaviour of the kernel, as far as the ACPI spec goes, is to be broken.

The ACPI spec requires IPMI functionality before a module loads at
boot time?  And the kernel is *broken* if it does not support ACIP IPMI
functionality before module load time?  Really?


> >> If you have specific bug reports, that would be helpful. But you're not
> > > describing actual failure conditions or showing any willingness to
> > > figure out what the underlying problem is.
> > 
> > You can't fix your problem without creating problems for
> > others to fix?
> 
> ACPI 4.0 includes support for IPMI operation regions. Modular IPMI means
> that the kernel will spend a significant amount of time (potentially
> until a user manually loads a driver) failing to implement part of the
> IPMI specification. That's a problem, and the correct fix is to ensure
> that the kernel always implements IPMI support.

The ACPI spec says ipmi_si cannot be a driver?  Really?
What is the real problem you are trying to solve?


> Now, you've described some other problems. I don't disagree that those
> are problems. The correct thing for us to do with those problems is to
> fix them, not to simply change the kernel defaults such that it's
> possible for users to choose between two differently broken states. I'm
> absolutely willing to help, as long as you're willing to put some
> reasonable amount of effort into describing them.

How about ACPI IPMI functionality starts when the ipmi_si
module loads at boot time.  

-- 
Russ Anderson,  Kernel and Performance Software Team Manager
SGI - Silicon Graphics Inc          rja@sgi.com
