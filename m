Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab3KRXPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 18:15:42 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34288 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab3KRXPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 18:15:39 -0500
Date: Mon, 18 Nov 2013 23:15:06 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch] mm, memcg: add memory.oom_control notification for
 system oom
Message-ID: <20131118231506.32ec2467@alan.etchedpixels.co.uk>
In-Reply-To: <20131118155450.GB3556@cmpxchg.org>
References: <alpine.DEB.2.02.1310301838300.13556@chino.kir.corp.google.com>
	<20131031054942.GA26301@cmpxchg.org>
	<alpine.DEB.2.02.1311131416460.23211@chino.kir.corp.google.com>
	<20131113233419.GJ707@cmpxchg.org>
	<alpine.DEB.2.02.1311131649110.6735@chino.kir.corp.google.com>
	<20131114032508.GL707@cmpxchg.org>
	<alpine.DEB.2.02.1311141447160.21413@chino.kir.corp.google.com>
	<20131118155450.GB3556@cmpxchg.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And accessing the emergency reserves means we are definitely no longer
> A-OK, this is not comparable to the first direct reclaim invocation.
> 
> We exhausted our options and we got really lucky.  It should not be
> considered the baseline and a user listening for "OOM conditions"
> should be informed about this.

Definitely concur - there are loading tuning cases where you want to
drive the box to the point it starts whining and then scale back a touch.

It's an API change in effect, and while I can believe there are good
arguments for both any API change ought to be a new API for listening
only to serious OOM cases.
