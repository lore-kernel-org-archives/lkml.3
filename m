Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab3C0C7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 22:59:11 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:47761 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab3C0C7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 22:59:10 -0400
X-AuditID: 9c930197-b7c9dae000006959-5a-5152607b539f
Date: Wed, 27 Mar 2013 11:59:57 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>
Subject: Re: [RT LATENCY] 249 microsecond latency caused by slub's
 unfreeze_partials() code.
Message-ID: <20130327025957.GA17125@lge.com>
References: <1363906545.6345.81.camel@gandalf.local.home>
 <0000013d92c37ff3-5fb85400-bec1-4eda-8ba1-332566884c59-000000@email.amazonses.com>
 <1364010673.6345.156.camel@gandalf.local.home>
 <0000013da1f93be3-c3d42ae8-ff34-4c63-8094-77a83291ea19-000000@email.amazonses.com>
 <1364227073.6345.182.camel@gandalf.local.home>
 <1364228039.6345.183.camel@gandalf.local.home>
 <0000013da2ace21a-9e87fe8a-75c2-4b7c-b5e1-37ad196ce012-000000@email.amazonses.com>
 <1364234613.6345.184.camel@gandalf.local.home>
 <0000013da2ce20f8-0e3a64ef-67ed-4ab4-9f20-b77980c876c3-000000@email.amazonses.com>
 <1364236355.6345.185.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364236355.6345.185.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 02:32:35PM -0400, Steven Rostedt wrote:
> On Mon, 2013-03-25 at 18:27 +0000, Christoph Lameter wrote:
> > On Mon, 25 Mar 2013, Steven Rostedt wrote:
> > 
> > > If this makes it more deterministic, and lower worse case latencies,
> > > then it's definitely worth the price.
> > 
> > Yes that would make it more deterministic. Maybe I should add an option
> > to be able to compile the allocator without cpu partial page support?
> 
> I agree that would be useful.

Hello, Steven and Christoph.

How about using spin_try_lock() in unfreeze_partials() and
using spin_lock_contented() in get_partial_node() to reduce latency?
IMHO, this doesn't make code more deterministic, but can maintain
a benefit of cpu partial page with tolerable latency.

Thanks.

> 
> -- Steve
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
