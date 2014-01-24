Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbaAXPo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 10:44:27 -0500
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:57278
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752728AbaAXPoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 10:44:23 -0500
Date: Fri, 24 Jan 2014 09:44:20 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Mel Gorman <mgorman@suse.de>
cc: Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] really large storage sectors - going
 beyond 4096 bytes
In-Reply-To: <20140124110928.GR4963@suse.de>
Message-ID: <alpine.DEB.2.10.1401240941190.12665@nuc>
References: <20131220093022.GV11295@suse.de> <52DF353D.6050300@redhat.com> <20140122093435.GS4963@suse.de> <alpine.DEB.2.10.1401231436300.8031@nuc> <20140124110928.GR4963@suse.de>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jan 2014, Mel Gorman wrote:

> That'd be okish for 64-bit at least although it would show up as
> degraded performance in some cases when virtually contiguous buffers were
> used. Aside from the higher setup, access costs and teardown costs of a
> virtual contiguous buffer, the underlying storage would no longer gets
> a single buffer as part of the IO request. Would that not offset many of
> the advantages?

It would offset some of that. But the major benefit of large order page
cache was the reduction of the number of operations that the kernel has to
perform. A 64k page contains 16 4k pages. So there is only one kernel
operation required instead of 16. If the page is virtually allocated then
the higher level kernel functions still only operate on one page struct.
The lower levels (bio) then will have to deal with the virtuall mappings
and create a scatter gather list. This is some more overhead but not much.

Doing something like this will put more stress on the defragmentation
logic in the kernel. In general I think we need more contiguous physical
memory.

