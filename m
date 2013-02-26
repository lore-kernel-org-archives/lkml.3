Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759862Ab3BZEXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 23:23:55 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:36941 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759803Ab3BZEXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 23:23:52 -0500
Date: Tue, 26 Feb 2013 04:23:38 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226042338.GA30944@srcf.ucam.org>
References: <18738.1361836265@warthog.procyon.org.uk>
 <20130226005955.GA19686@kroah.com>
 <20130226023332.GA29282@srcf.ucam.org>
 <20130226030249.GB23834@kroah.com>
 <20130226031338.GA29784@srcf.ucam.org>
 <20130226033156.GA24999@kroah.com>
 <20130226033803.GA30285@srcf.ucam.org>
 <20130226035416.GA1128@kroah.com>
 <20130226040456.GA30717@srcf.ucam.org>
 <20130226041324.GA7241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130226041324.GA7241@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 08:13:24PM -0800, Greg KH wrote:
> On Tue, Feb 26, 2013 at 04:04:56AM +0000, Matthew Garrett wrote:
> > There's no reason for the LF or generic shim to be blacklisted, since 
> > neither will load anything without manual intervention. But that also 
> > means that anyone trying to boot them has to have some knowledge of 
> > English, and that there's no way to netboot them. But sure, anyone 
> > planning that approach has much less to worry about.
> 
> I don't see anything about "manual intervention" in the wording that you
> provided from Microsoft absolving you from the "duty" you feel you owe
> them.  I understand you are worried about "automated" exploits, but that
> really is just a semantic overall, as we know it is easy to get people
> to hit a key when booting just to get on with the process.

If the user has explicitly enrolled a hash then they're stepping outside 
the trust model. That's why the LF loader shows dire warnings, and why 
shim has deliberately awkward UI. Perhaps we'll have made an incorrect 
judgement and it'll turn out that users can still be manipulated into 
being exploited this way, and in that case we'll have to reappraise some 
of those choices. But given that the barrier there is similar to the 
barrier involved in just telling users to disable Secure Boot entirely, 
I don't think it's terribly likely.

> > > Yes you can.  There are all sorts of fun ways you can do this, I can
> > > think of a few more at the moment as well.  So, where does it stop?
> > > And why stop it at all?  Why not just forbid root users at all?
> > 
> > Because there's a distinction between ring 0 and ring 3?
> 
> Since when did you start trusting ring 0 code?  Bozos like me write this
> stuff, surely it isn't secure :)

The fact that we bother with CVEs seems to suggest that we at least 
aspire to it...

> > Right. We've failed at creating an alternative. That doesn't mean that 
> > we get to skip the responsibilities associated with the choice we've 
> > made.
> 
> Wait, who is "we" here?  The community?  The community over-all didn't
> agree with anything with Microsoft, that is between the people getting a
> signed key and Microsoft.  Again, you are trying to push your (prior)
> company's agreement between them and Microsoft onto the community, and
> now the community is pushing back, is that a surprise?

The community's not obliged to take the patches, and I'm sure Red Hat 
and any other vendors who care can carry them themselves. But it'd be 
nice to avoid even more divergence between upstream and the 
distributions, wouldn't it?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
