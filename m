Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbbAWUEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 15:04:07 -0500
Received: from mga03.intel.com ([134.134.136.65]:13304 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbbAWUEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 15:04:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="444334126"
Message-ID: <54C2A931.5020308@linux.intel.com>
Date: Fri, 23 Jan 2015 14:04:01 -0600
From: Tom Zanussi <tom.zanussi@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, josh@joshtriplett.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] drivers/char: Support compiling out the getrandom(2)
 syscall
References: <cover.1422035184.git.tom.zanussi@linux.intel.com> <87fec26efb0a0e4a8daab238ee39261dca2dc985.1422035184.git.tom.zanussi@linux.intel.com> <20150123194610.GD8709@thunk.org>
In-Reply-To: <20150123194610.GD8709@thunk.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/23/2015 01:46 PM, Theodore Ts'o wrote:
> On Fri, Jan 23, 2015 at 12:37:16PM -0600, Tom Zanussi wrote:
>> Many embedded systems have no use for getrandom, and could benefit
>> from the size savings gained by omitting it.  Add a new EXPERT config
>> option, CONFIG_GETRANDOM_SYSCALL (default y), to support compiling it
>> out.
>
> I'm really not sure this is a good idea.  Even the tiniest embedded
> device need secure crypto.  In fact, one could argue that in the case
> of the Internet of Things, the tiniests embedded devices
> **especially** need secure crypto.  It would be.... unfortunate.... if
> the next time North Korea gets upset at the Great Satan, that all of
> our light bulbs, refridgerators, cars, heating systems, etc., are
> subject to attack.
>

Right, but not everything is networked - there are standalone embedded 
systems that could benefit from the savings.  Anyway, it's not a huge 
savings so I could just remove them to avoid the temptation...

Tom.

> We know already that home routers are running ancient kernels that are
> absolutely no protection whatever.  Is saving a few bytes really worth
> potentially opening up a similar attack vector on devices that will
> probably be at least an order of magnitude or more numerous than home
> routers, and even harder to upgrade once they get out there?
>
> And if you don't have a good random number generator, you really are
> *toast*.
>
> It's for this reason that /dev/[u]random were not eligible from being
> disabled from the very beginning; it's too much of an attractive
> nuisance to a clueless product manager....
>
> 	     	  	    	    	 - Ted
>
