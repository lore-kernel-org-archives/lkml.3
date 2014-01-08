Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156AbaAHXX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 18:23:27 -0500
Received: from one.firstfloor.org ([193.170.194.197]:40870 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757565AbaAHXXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 18:23:24 -0500
Date: Thu, 9 Jan 2014 00:23:22 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lockdep: increase static allocations
Message-ID: <20140108232322.GH20765@two.firstfloor.org>
References: <1389208906-24338-1-git-send-email-sasha.levin@oracle.com>
 <87lhyq45go.fsf@tassilo.jf.intel.com>
 <52CDB0CF.5060904@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CDB0CF.5060904@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 03:10:55PM -0500, Sasha Levin wrote:
> On 01/08/2014 02:51 PM, Andi Kleen wrote:
> >Sasha Levin <sasha.levin@oracle.com> writes:
> >
> >>Fuzzing a recent kernel with a large configuration hits the static
> >>allocation limits and disables lockdep.
> >
> >Doesn't that use a lot more memory?  I thought lockdep preallocates.
> >
> >Doubling may be too aggressive.
> 
> The patch adds about 4MB of memory usage, I didn't think it's too much for something
> that is only enabled during debugging.

Wasting 4MB is an issue.

Linus' first Linux system had less total memory than that.

> 
> If this is an issue, can I suggest making these values configurable in the .config
> and just let users pick whatever they want?

Better allocate it at boot time, using a boot parameter or somesuch.

-Andi
