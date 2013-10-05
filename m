Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab3JETDf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 15:03:35 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:38062 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab3JETDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 15:03:34 -0400
X-Originating-IP: 50.43.39.152
Date: Sat, 5 Oct 2013 12:03:25 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] checkpatch.pl: Check for the FSF mailing address
Message-ID: <20131005190325.GS5771@leaf>
References: <20131005184307.GA6429@leaf>
 <1380999108.2081.138.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380999108.2081.138.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 05, 2013 at 11:51:48AM -0700, Joe Perches wrote:
> On Sat, 2013-10-05 at 11:43 -0700, Josh Triplett wrote:
> > Kernel maintainers reject new instances of the GPL boilerplate paragraph
> > directing people to write to the FSF for a copy of the GPL, since the
> > FSF has moved in the past and may do so again.
> []
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> []
> > @@ -1859,6 +1859,16 @@ sub process {
> >  			$rpt_cleaners = 1;
> >  		}
> >  
> > +# Check for FSF mailing addresses.
> > +		if ($rawline =~ /You should have received a copy/ ||
> 
> There are over 9,000 of these in the tree.
> 
> > +		    $rawline =~ /write to the Free Software/ ||
> 
> Over 7,000
> 
> > +		    $rawline =~ /59 Temple Place/ ||
> 
> Over 3,500
> 
> > +		    $rawline =~ /51 Franklin Street/) {
> 
> Over 1,500

And there shouldn't be any more added.  (Also, case in point, note that
the FSF is no longer at "59 Temple Place".)

> > +			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
> > +			ERROR("FSF_MAILING_ADDRESS",
> > +			      "Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.\n" . $herevet)
> 
> Is this really a useful ERROR condition?
> Maybe a CHK --strict test or a warning instead?

How about making it a hard ERROR in patch mode, making "59 Temple Place"
an error in any mode, and making the other lines only warnings in file
mode?

Note that I made it an error because for many maintainers it's an
automatic patch rejection.

- Josh Triplett
