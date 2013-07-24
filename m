Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab3GXTXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 15:23:10 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:7913
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751579Ab3GXTXI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 15:23:08 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1155h)
Date: Wed, 24 Jul 2013 14:22:53 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH] module: ppc64 module CRC relocation fix causes perf
 issues
To: Michael Ellerman <michael@ellerman.id.au>
CC: Anton Blanchard <anton@samba.org>, Neil Horman <nhorman@tuxdriver.com>,
        Rusty Russell <rusty@rustcorp.com.au>, <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <20130723133032.GB31944@concordia> (from michael@ellerman.id.au
	on Tue Jul 23 08:30:32 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1374693773.15592.59@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 08:30:32 AM, Michael Ellerman wrote:
> On Fri, Jul 19, 2013 at 05:59:30PM -0500, Scott Wood wrote:
> > On 07/17/2013 11:00:45 PM, Anton Blanchard wrote:
> > >
> > >Hi Scott,
> > >
> > >> What specifically should I do to test it?
> > >
> > >Could you double check perf annotate works? I'm 99% sure it will  
> but
> > >that is what was failing on ppc64.
> >
> > I'm not really sure what it's supposed to look like when "perf
> > annotate" works.  It spits a bunch of unreadable[1]
> > dark-blue-on-black assembly code at me, all with "0.00 :" in the
> > left column.
> >
> > Oh, wait -- some lines have "100.00 : " on the left, in
> > even-more-unreadable dark-red-on-black.
> >
> > Apart from the annoying colors, is there anything specific I should
> > be looking for?  Some sort of error message, or output that actually
> > makes sense?
> 
> The colours look fine on my terminal, so I don't know what you've done
> there.

It probably looks better if the terminal is configured to have a light  
background (which of course makes some other programs look worse), or  
(as I noted) if you've got your monitor set to be very bright.  I now  
see that xfce4-terminal lets me redefine the standard colors, though,  
so that should help.

> If you care you can use "--stdio" to use the plainer interface,
> though it still uses colours.
> 
> That output looks fine in terms of the bug Anton was chasing. As far  
> as
> only ever hitting one instruction that does look weird.

OK.  I'll add "investigate weird e500 perf annotate results" to the  
TODO list...

-Scott
