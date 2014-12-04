Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbaLDPhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:37:19 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:42798 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbaLDPhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:37:17 -0500
Message-ID: <54807FC3.9050305@gmail.com>
Date: Thu, 04 Dec 2014 10:37:39 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>
Subject: Re: [RFC PATCH v2] tinification: Introduce CONFIG_SRCU to make SRCU
 optional
References: <1417665832-6933-1-git-send-email-bobby.prani@gmail.com> <20141204062704.GH25340@linux.vnet.ibm.com>
In-Reply-To: <20141204062704.GH25340@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2014 01:27 AM, Paul E. McKenney wrote:
> For the moment, I applied this to -rcu against v3.18-rc6 to get some 0day
> testing on it.
> 
> There are conflicts against the tip of my tree, but will worry about
> that later.  I don't have a ready answer on whether or not this needs
> to be split up -- in the worst case, we would add the SRCU Kconfig
> parameter, add all the selects, then once they all hit mainline add the
> Makefile change.
> 
> We will need stats on how much memory was saved, and a "size kernel/rcu/srcu.o"
> after a UP/tiny build should do it.  Could you please add this to the
> commit log?
> 

So if we do not select CONFIG_SRCU, srcu.o will not be compiled at all. So we should save about

   text	   data	    bss	    dec	    hex	filename
   2007	      0	      0	   2007	    7d7	kernel/rcu/srcu.o

as in size of arch/powerpc/boot/zImage changes from

   text	   data	    bss	    dec	    hex	filename
 831552	  64180	  23944	 919676	  e087c	arch/powerpc/boot/zImage : before
 829504	  64180	  23952	 917636	  e0084	arch/powerpc/boot/zImage : after

so about ~2000 bytes I guess. 

--
Pranith

