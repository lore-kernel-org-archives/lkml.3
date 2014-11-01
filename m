Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbaKAMaQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 08:30:16 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:16615 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752765AbaKAMaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 08:30:14 -0400
Date: Sat, 1 Nov 2014 08:30:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Rik van Riel <riel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] mm/page-writeback.c: divide by zero in pos_ratio_polynom
 not fixed
Message-ID: <20141101083012.54d3b59b@gandalf.local.home>
In-Reply-To: <20141101082325.7be0463f@gandalf.local.home>
References: <20141101082325.7be0463f@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Nov 2014 08:23:25 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> I don't see how d5c9fde3dae75
> could have fixed anything.

I take that back. It fixes the case on 64 bit systems where the
parameter of div_u64() truncates it. But it does nothing to help the
situation on 32 bit systems.

-- Steve
