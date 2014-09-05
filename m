Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbaIEULm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:11:42 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:39898 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbaIEUJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:09:33 -0400
Date: Fri, 5 Sep 2014 13:09:26 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Michael Cree <mcree@orcon.net.nz>, "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Miroslav Franc <mfranc@redhat.com>,
        Richard Henderson <rth@twiddle.net>, linux-alpha@vger.kernel.org
Subject: Re: bit fields && data tearing
Message-ID: <20140905200926.GW5001@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <063D6719AE5E284EB5DD2968C1650D6D17487172@AcuExch.aculab.com>
 <1409824374.4246.62.camel@pasglop>
 <5408E458.3@zytor.com>
 <54090AF4.7060406@hurleysoftware.com>
 <54091B30.2090509@zytor.com>
 <20140905081648.GB5281@omega>
 <20140905180950.GU5001@linux.vnet.ibm.com>
 <540A05F7.1070202@hurleysoftware.com>
 <20140905190506.GV5001@linux.vnet.ibm.com>
 <540A0DF3.8030802@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540A0DF3.8030802@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090520-7164-0000-0000-00000463DE91
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 03:24:35PM -0400, Peter Hurley wrote:
> On 09/05/2014 03:05 PM, Paul E. McKenney wrote:
> > On Fri, Sep 05, 2014 at 02:50:31PM -0400, Peter Hurley wrote:
> >> On 09/05/2014 02:09 PM, Paul E. McKenney wrote:
> 
> [cut]
> 
> >>> ------------------------------------------------------------------------
> >>>
> >>> documentation: Record limitations of bitfields and small variables
> >>>
> >>> This commit documents the fact that it is not safe to use bitfields as
> >>> shared variables in synchronization algorithms.  It also documents that
> >>> CPUs must provide one-byte and two-byte load and store instructions
> >>                    ^
> >>                 atomic
> > 
> > Here you meant non-atomic?  My guess is that you are referring to the
> > fact that you could emulate a one-byte store on pre-EV56 Alpha CPUs
> > using the ll and sc atomic-read-modify-write instructions, correct?
> 
> Yes, that's what I meant. I must be tired and am misreading the commit
> message, or misinterpreting it's meaning.

Very good, got it!

							Thanx, Paul

