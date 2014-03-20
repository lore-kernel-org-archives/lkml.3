Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759162AbaCTPGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:06:09 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:36117 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbaCTPGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:06:06 -0400
Date: Thu, 20 Mar 2014 08:06:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Monam Agarwal <monamagarwal123@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, eddie.wai@broadcom.com
Subject: Re: [PATCH 0/9] Replace rcu_assign_pointer(x, NULL) with
 RCU_INIT_POINTER(x,NULL)
Message-ID: <20140320150601.GK4405@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1395324808.git.monamagarwal123@gmail.com>
 <532B022C.8010505@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532B022C.8010505@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032015-6688-0000-0000-0000008464E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 03:58:52PM +0100, Arend van Spriel wrote:
> On 20/03/14 15:37, Monam Agarwal wrote:
> >This patchset uses following coccinelle script to replace
> >rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x,NULL)
> >
> >@@
> >expression E;
> >@@
> >- rcu_assign_pointer(
> >+ RCU_INIT_POINTER(
> >E, NULL)
> 
> I am not very familiar with rcu functionality nor coccinelle, but it
> looks too generic. I would think only NULL assignments during
> initialization should use RCU_INIT_POINTER(). The first patch in the
> series does it in a function called unregister_...(). Is it really
> ok to do there?

Hello, Arend,

The thing that rcu_assign_pointer() is doing is ensuring that the
initialization of a structure is carried out before storing a pointer
to that structure.  In the case of the NULL pointer, there is no
structure to initialize, so nothing need be ordered.

So, yes, rcu_assign_pointer(p, NULL) can always safely be converted to
RCU_INIT_POINTER(p, NULL).  ;-)

							Thanx, Paul

