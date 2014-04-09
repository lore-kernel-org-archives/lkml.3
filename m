Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933896AbaDIWuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 18:50:04 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:28657 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932719AbaDIWuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 18:50:02 -0400
Message-ID: <1397083799.2608.20.camel@buesod1.americas.hpqcorp.net>
Subject: Re: hpsa driver bug crack kernel down!
From: Davidlohr Bueso <davidlohr@hp.com>
To: Baoquan He <bhe@redhat.com>
Cc: linux-kernel@vger.kernel.org, scameron@beardog.cce.hp.com,
        James.Bottomley@HansenPartnership.com
Date: Wed, 09 Apr 2014 15:49:59 -0700
In-Reply-To: <20140409023935.GE11839@dhcp-16-105.nay.redhat.com>
References: <20140409023935.GE11839@dhcp-16-105.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-09 at 10:39 +0800, Baoquan He wrote:
> Hi,
> 
> The kernel is 3.14.0+ which is pulled just now. 

Cc'ing more people.

While the hpsa driver appears to be involved in some way, I'm sure if
this is a related issue, but as of today's pull I'm getting another
problem that causes my DL980 not to come up.

*Massive* amounts of:

DMAR:[fault reason 02] Present bit in context entry is clear
dmar: DRHD: handling fault status reg 602
dmar: DMAR:[DMA Read] Request device [02:00.0] fault addr 7f61e000

Then:

hpsa 0000:03:00.0: Controller lockup detected: 0xffff0000
...
Workqueue: events hpsa_monitor_ctlr_worker [hpsa]
...

Screenshot of the actual LOCKUP: 
http://stgolabs.net/hpsa-hard-lockup-3.14+.png

While I haven't bisected, things worked fine until at least until commit
39de65aa2c3e (April 2nd).

Any ideas?

Thanks,
Davidlohr

