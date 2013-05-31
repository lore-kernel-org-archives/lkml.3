Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab3EaOmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 10:42:46 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60781 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207Ab3EaOmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 10:42:40 -0400
Message-ID: <1370011357.1913.15.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Jiri Kosina <jkosina@suse.cz>, Russ Anderson <rja@sgi.com>,
        joeyli <jlee@suse.com>, Matt Fleming <matt@console-pimps.org>,
        matt.fleming@intel.com, linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 31 May 2013 07:42:37 -0700
In-Reply-To: <20130531143425.GA5850@srcf.ucam.org>
References: <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz>
	 <20130529224645.GA16582@sgi.com>
	 <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz>
	 <1369880172.17397.11.camel@linux-s257.site>
	 <20130530221737.GA11105@sgi.com>
	 <alpine.LNX.2.00.1305310023020.30576@pobox.suse.cz>
	 <20130531101250.GD30394@gmail.com>
	 <alpine.LNX.2.00.1305311259520.30576@pobox.suse.cz>
	 <20130531123015.GC17843@nazgul.tnic> <20130531124356.GA8212@gmail.com>
	 <20130531143425.GA5850@srcf.ucam.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-31 at 15:34 +0100, Matthew Garrett wrote:
> On Fri, May 31, 2013 at 02:43:56PM +0200, Ingo Molnar wrote:
> 
> > 4) The revert is easy, and the functionality the original patch provided
> >    was a marginal increase in debug output to begin with...
> 
> I agree that a revert is probably the right thing to do here, but the 
> original patch was there to permit a more accurate calculation of the 
> amount of nvram in use, not to provide additional debug information. 
> Reverting it is going to differently break a different set of systems

The only ones that are broken are the Samsung ones.  Samsung claims to
have fixed their UEFI firmware, so we could refer any problems to them.

The signature of the Samsung failure, which this is guarding against is
that the laptop gets bricked, so it really is a nasty choice of poisons
we have to pick...

Could we hedge the QueryVariableInfo checks with a test for Samsung in
the UEFI identity strings?

James



