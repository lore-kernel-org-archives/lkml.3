Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaEGEdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 00:33:50 -0400
Received: from one.firstfloor.org ([193.170.194.197]:59488 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbaEGEds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 00:33:48 -0400
Date: Wed, 7 May 2014 06:33:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>,
        Richard Cochran <richardcochran@gmail.com>, josh@joshtriplett.org,
        David Miller <davem@davemloft.net>, andi@firstfloor.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
Message-ID: <20140507043346.GE5619@two.firstfloor.org>
References: <20140506032114.GP2382@two.firstfloor.org>
 <20140505.232327.578134514220748085.davem@davemloft.net>
 <20140506155703.GA20391@cloud>
 <20140506.115941.428706504757835279.davem@davemloft.net>
 <20140506164108.GA20536@cloud>
 <20140506191447.GB4137@netboy>
 <20140506195049.GO19657@tassilo.jf.intel.com>
 <20140506200738.GA17813@netboy>
 <20140506210549.GR19657@tassilo.jf.intel.com>
 <1399418979.15399.107.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399418979.15399.107.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 04:29:39PM -0700, Eric Dumazet wrote:
> On Tue, 2014-05-06 at 14:05 -0700, Andi Kleen wrote:
> 
> > - Make GRO optional.
> > This is purely a performance feature for high bandwidth.
> 
> Make this properly then, instead of relying on LTO.
> 
> We did preliminary work to put this stuff in separate files, but its not
> complete yet.

FWIW doesn't matter for LTO.

> 
> tcpv4_offload has pointers to tcp4_gro_receive() and tcp4_gro_complete()
> 
> Is LTO smart enough to understand this will never be called, and do
> proper code elimination of whole _gro_ helpers ?

When there are pointers in static objects it cannot eliminate it for C
(it may work for C++)

However if you just  remove the pointer it'll remove the rest.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
