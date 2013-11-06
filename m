Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab3KFUA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 15:00:59 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:53465 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab3KFUA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 15:00:57 -0500
Date: Wed, 6 Nov 2013 12:00:44 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] srcu: API for barrier after srcu read unlock
Message-ID: <20131106200044.GN18245@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1383592884-2535-1-git-send-email-mst@redhat.com>
 <20131104205524.GY3947@linux.vnet.ibm.com>
 <527A5985.6050309@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527A5985.6050309@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110620-6688-0000-0000-0000033C7B57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 11:00:21PM +0800, Lai Jiangshan wrote:
> On 11/05/2013 04:55 AM, Paul E. McKenney wrote:
> > On Mon, Nov 04, 2013 at 10:36:17PM +0200, Michael S. Tsirkin wrote:
> >> srcu read lock/unlock include a full memory barrier
> >> but that's an implementation detail.
> >> Add an API for make memory fencing explicit for
> >> users that need this barrier, to make sure we
> >> can change it as needed without breaking all users.
> >>
> >> Acked-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> >> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > 
> > Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Acked-by: "Lai Jiangshan" <laijs@cn.fujitsu.com>

Very good, queued for 3.14.

							Thanx, Paul

> >> ---
> >>  include/linux/srcu.h | 14 ++++++++++++++
> >>  1 file changed, 14 insertions(+)
> >>
> >> diff --git a/include/linux/srcu.h b/include/linux/srcu.h
> >> index c114614..9b058ee 100644
> >> --- a/include/linux/srcu.h
> >> +++ b/include/linux/srcu.h
> >> @@ -237,4 +237,18 @@ static inline void srcu_read_unlock(struct srcu_struct *sp, int idx)
> >>  	__srcu_read_unlock(sp, idx);
> >>  }
> >>
> >> +/**
> >> + * smp_mb__after_srcu_read_unlock - ensure full ordering after srcu_read_unlock
> >> + *
> >> + * Converts the preceding srcu_read_unlock into a two-way memory barrier.
> >> + *
> >> + * Call this after srcu_read_unlock, to guarantee that all memory operations
> >> + * that occur after smp_mb__after_srcu_read_unlock will appear to happen after
> >> + * the preceding srcu_read_unlock.
> >> + */
> >> +static inline void smp_mb__after_srcu_read_unlock(void)
> >> +{
> >> +	/* __srcu_read_unlock has smp_mb() internally so nothing to do here. */
> >> +}
> >> +
> >>  #endif
> >> -- 
> >> MST
> >>
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> 

