Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbaAII4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 03:56:53 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54094 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbaAII4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 03:56:43 -0500
Date: Thu, 9 Jan 2014 09:56:31 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lockdep: increase static allocations
Message-ID: <20140109085631.GC7572@laptop.programming.kicks-ass.net>
References: <1389208906-24338-1-git-send-email-sasha.levin@oracle.com>
 <87lhyq45go.fsf@tassilo.jf.intel.com>
 <52CDB0CF.5060904@oracle.com>
 <20140108232322.GH20765@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140108232322.GH20765@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 12:23:22AM +0100, Andi Kleen wrote:
> On Wed, Jan 08, 2014 at 03:10:55PM -0500, Sasha Levin wrote:
> > On 01/08/2014 02:51 PM, Andi Kleen wrote:
> > >Sasha Levin <sasha.levin@oracle.com> writes:
> > >
> > >>Fuzzing a recent kernel with a large configuration hits the static
> > >>allocation limits and disables lockdep.
> > >
> > >Doesn't that use a lot more memory?  I thought lockdep preallocates.
> > >
> > >Doubling may be too aggressive.
> > 
> > The patch adds about 4MB of memory usage, I didn't think it's too much for something
> > that is only enabled during debugging.
> 
> Wasting 4MB is an issue.
> 
> Linus' first Linux system had less total memory than that.

Meh.. if someone from the embedded people care we can add
CONFIG_BASE_SMALL option, until then I couldn't care less about 4m.

> > 
> > If this is an issue, can I suggest making these values configurable in the .config
> > and just let users pick whatever they want?
> 
> Better allocate it at boot time, using a boot parameter or somesuch.

wrongbot andi is at it again.. no that's far too late.
