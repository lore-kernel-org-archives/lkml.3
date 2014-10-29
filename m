Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624AbaJ2LAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 07:00:48 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:46955 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369AbaJ2LAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 07:00:47 -0400
Date: Wed, 29 Oct 2014 12:00:42 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, eranian@google.com,
        dzickus@redhat.com, jmario@redhat.com, acme@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Attempt to cleanup the HSW offcore bits
Message-ID: <20141029110042.GA12099@gmail.com>
References: <20141023105119.173457103@infradead.org>
 <20141027122340.GU12538@two.firstfloor.org>
 <20141027130712.GF3337@twins.programming.kicks-ass.net>
 <20141027142818.GA3041@tassilo.jf.intel.com>
 <alpine.DEB.2.11.1410282243510.5308@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1410282243510.5308@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> Andi,
> 
> On Mon, 27 Oct 2014, Andi Kleen wrote:
> > On Mon, Oct 27, 2014 at 02:07:12PM +0100, Peter Zijlstra wrote:
> > > On Mon, Oct 27, 2014 at 01:23:40PM +0100, Andi Kleen wrote:
> > > > On Thu, Oct 23, 2014 at 12:51:19PM +0200, Peter Zijlstra wrote:
> > > > > So Don asked about offcore and because I forgot I looked at the code and found
> > > > > the terrible mess Andi created with the HSW/BDW bits.
> > > > > 
> > > > > This series attempts to clean some of that up but seeing how it was all magic
> > > > > numbers 
> > > > 
> > > > All the bits are documented. The actual definitions are available
> > > > in the JSON offcore definitions at https://download.01.org/perfmon/
> > > 
> > > Yeah, no. That's not how we write code. Also, there's no actual JSON
> > > offcore file for HSW only some TSV file, and I've no mind to go decode
> > 
> > https://download.01.org/perfmon/HSW/Haswell_matrix_V14.json
> > https://download.01.org/perfmon/HSW/Haswell_matrix_bit_definitions_V14.json
> 
> Of course you did not answer any of the other legitimate 
> questions Peter brought up.
> 
> Care to answer them w/o pointing to magic json files which lack 
> ANY useful information about the magic bits they provide? And 
> why they are not consistent with the SDM?
> 
> Either you come forth with reasonable explanations or I'm going 
> to rip out the mess you created even before Peter can persuade 
> himself to do so.

So I waited a week in the hope that all this can be resolved 
quickly, but the problem is that we are already at -rc3 and we 
are running out of time and I'm not seeing constructive behavior 
from Andi.

So I've done a straightforward revert of the messy Broadwell 
client driver changes, to bring us back to the v3.17 baseline:

  1776b10627e4 ("perf/x86/intel: Revert incomplete and undocumented Broadwell client support")

Andi, please rework the series on top of that and also 
proactively integrate the cleanups, requests and observations 
from Thomas Gleixner and Peter Zijlstra. Only submit a new series 
once all feedback given to you in the past has been addressed to 
the fullest!

If the patches are fixed quickly enough then we might be able to 
merge support in v3.19. If not then it has to wait until v3.20 or 
later kernels.

Thanks,

	Ingo
