Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbaFUCEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 22:04:43 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:17034 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753880AbaFUCEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 22:04:41 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18m9ZkRjmQfP8ZU5wMwXVMypoCi/RtVImM=
X-DKIM: OpenDKIM Filter v2.0.1 titan 7F627594FF8
Date: Fri, 20 Jun 2014 22:04:30 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Jonas Bonn <jonas@southpole.se>, Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux <linux@openrisc.net>, Thomas Gleixner <tglx@linutronix.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4] openrisc: irq: use irqchip framework
Message-ID: <20140621020430.GA21711@titan.lakedaemon.net>
References: <1401136302-27654-1-git-send-email-stefan.kristiansson@saunalahti.fi>
 <CAMuHMdUUqaRP2M0hPh5k0nPp1a_t0W98Vc_4zAQMjGYZZOPd8w@mail.gmail.com>
 <53843508.7060007@southpole.se>
 <20140529202806.GA9387@chokladfabriken.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529202806.GA9387@chokladfabriken.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 11:28:08PM +0300, Stefan Kristiansson wrote:
> On Tue, May 27, 2014 at 08:47:36AM +0200, Jonas Bonn wrote:
> > On 05/26/2014 10:52 PM, Geert Uytterhoeven wrote:
> > > CC devicetree for the bindings
> > > 
> > > On Mon, May 26, 2014 at 10:31 PM, Stefan Kristiansson
> > > <stefan.kristiansson@saunalahti.fi> wrote:
> > >> +++ b/Documentation/devicetree/bindings/interrupt-controller/opencores,or1k-pic.txt
> > >> @@ -0,0 +1,23 @@
> > >> +OpenRISC 1000 Programmable Interrupt Controller
> > >> +
> > >> +Required properties:
> > >> +
> > >> +- compatible : should be "opencores,or1k-pic-level" for variants with
> > >> +  level triggered interrupt lines, "opencores,or1k-pic-edge" for variants with
> > >> +  edge triggered interrupt lines or "opencores,or1200-pic" for machines
> > >> +  with the non-spec compliant or1200 type implementation.
> > >> +
> > >> +  "opencores,or1k-pic" is also provided as an alias to "opencores,or1200-pic",
> > >> +  but this is only for backwards compatibility.
> > 
> > I still think this identifier needs to be versioned.  Use the same
> > version number as we have on the cpu identifier since the OR1200 PIC
> > hasn't changed since then; i.e. opencores,or1200-pic-rtlsvnXYZ.
> > 
> 
> I can change that if you *really* insist on it...
> But I don't understand the purpose of the versioning here,
> there will never be any other or1200-pic version than the one that currently
> exists, so IMO "or1200" should be enough versioning information.

I'm horribly unfamiliar with openrisc, but compatible strings are
compatible strings. ;-)

Is the *actual* IP block called or1200-pic?  Or is it, eg or1235-pic, and
you're using or1200-pic as a generic catch-all?

Please use the specific IP name without wildcards.  That compatible
string will then be used on that IP and future IP that is compatible
with the original IP.  Once an incompatible change is introduced, then
we'll create a new compatible string, say or1300-pic, or or1237-pic.

When in doubt, be specific.  I don't think the '-rtlsvnXYZ' should be
necessary, though.

thx,

Jason.
