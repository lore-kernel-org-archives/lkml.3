Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaKKVFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 16:05:01 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:13171 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751877AbaKKVE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 16:04:58 -0500
Date: Tue, 11 Nov 2014 16:04:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Kara <jack@suse.cz>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] mm/page-writeback.c: divide by zero in pos_ratio_polynom
 not fixed
Message-ID: <20141111160448.61354836@gandalf.local.home>
In-Reply-To: <20141111201539.GA12333@quack.suse.cz>
References: <20141101082325.7be0463f@gandalf.local.home>
	<20141111201539.GA12333@quack.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2014 21:15:39 +0100
Jan Kara <jack@suse.cz> wrote:


>   So I was looking into this but I have to say I don't understand where is
> the problem. The registers clearly show that x_intercept - bdi_setpoint + 1
> == 0 (in 32-bit arithmetics). Given:
>    x_intercept = bdi_setpoint + span
> 
> We have that span + 1 == 0 and that means that:
> ((thresh - bdi_thresh + 8 * write_bw) * (u64)x >> 16) == -1 (again in
> 32-bit arithmetics). But I don't see how that can realistically happen...
> 
> Is this reproducible at all?
> 

Unfortunately not. It only happened once, and I haven't been able to
reproduce it again.

-- Steve
