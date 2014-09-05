Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbaIEIuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 04:50:21 -0400
Received: from mail.orcon.net.nz ([219.88.242.59]:33363 "EHLO
	mail.orcon.net.nz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751828AbaIEIuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 04:50:13 -0400
X-Greylist: delayed 1907 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Sep 2014 04:50:12 EDT
Date: Fri, 5 Sep 2014 20:16:48 +1200
From: Michael Cree <mcree@orcon.net.nz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Miroslav Franc <mfranc@redhat.com>,
        Richard Henderson <rth@twiddle.net>, linux-alpha@vger.kernel.org
Subject: Re: bit fields && data tearing
Message-ID: <20140905081648.GB5281@omega>
Mail-Followup-To: Michael Cree <mcree@orcon.net.nz>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Hurley <peter@hurleysoftware.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	David Laight <David.Laight@ACULAB.COM>,
	Jakub Jelinek <jakub@redhat.com>,
	"linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
	Tony Luck <tony.luck@intel.com>,
	"linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Paul Mackerras <paulus@samba.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	Miroslav Franc <mfranc@redhat.com>,
	Richard Henderson <rth@twiddle.net>, linux-alpha@vger.kernel.org
References: <20140712181328.GA8738@redhat.com>
 <54079B70.4050200@hurleysoftware.com>
 <1409785893.30640.118.camel@pasglop>
 <063D6719AE5E284EB5DD2968C1650D6D17487172@AcuExch.aculab.com>
 <1409824374.4246.62.camel@pasglop>
 <5408E458.3@zytor.com>
 <54090AF4.7060406@hurleysoftware.com>
 <54091B30.2090509@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54091B30.2090509@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Bayes-Prob: 0.0001 (Score 0: No Bayes scoring rules defined, tokens from: outbound)
X-Spam-Score: -2.63 () [Hold at 3.00] FREEMAIL_FROM:0.001,FSL_HELO_NON_FQDN_1:0.001,HELO_NO_DOMAIN:0.001,RDNS_DYNAMIC:0.363,CC(NZ:-3)
X-CanIt-Geo: ip=60.234.221.162; country=NZ; latitude=-41.0000; longitude=174.0000; http://maps.google.com/maps?q=-41.0000,174.0000&z=6
X-CanItPRO-Stream: base:outbound
X-Canit-Stats-ID: 01MLkgOEg - bf76787447f5 - 20140905
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 07:08:48PM -0700, H. Peter Anvin wrote:
> On 09/04/2014 05:59 PM, Peter Hurley wrote:
> > I have no idea how prevalent the ev56 is compared to the ev5.
> > Still we're talking about a chip that came out in 1996.
> 
> Ah yes, I stand corrected.  According to Wikipedia, the affected CPUs
> were all the 2106x CPUs (EV4, EV45, LCA4, LCA45) plus the 21164 with no
> suffix (EV5).  However, we're still talking about museum pieces here.

Yes, that is correct, EV56 is the first Alpha CPU to have the byte-word
extension (BWX) CPU instructions.

It would not worry me if the kernel decided to assume atomic aligned
scalar accesses for all arches, thus terminating support for Alphas
without BWX.

The X server, ever since the libpciaccess change, does not work on
Alphas without BWX.

Debian Alpha (pretty much up to date at Debian-Ports) is still compiled
for all Alphas, i.e., without BWX.  The last attempt to start compiling
Debian Alpha with BWX, about three years ago when Alpha was kicked out
to Debian-Ports resulted in a couple or so complaints so got nowhere.
It's frustrating supporting the lowest common demoninator as many of
the bugs specific to Alpha can be resolved by recompiling with the BWX.
The kernel no longer supporting Alphas without BWX might just be the
incentive we need to switch Debian Alpha to compiling with BWX.

Cheers
Michael.
