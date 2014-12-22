Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbaLVW1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 17:27:42 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:47386 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaLVW1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 17:27:41 -0500
Date: Mon, 22 Dec 2014 14:27:39 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave.hansen@linux.intel.com>
cc: Rafael Aquini <aquini@redhat.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, oleg@redhat.com, linux-mm@kvack.org
Subject: Re: [PATCH] proc: task_mmu: show page size in
 /proc/<pid>/numa_maps
In-Reply-To: <5495A698.4050707@linux.intel.com>
Message-ID: <alpine.DEB.2.10.1412221422120.11431@chino.kir.corp.google.com>
References: <c97f30472ec5fe79cb8fa8be66cc3d8509777990.1419079617.git.aquini@redhat.com> <5495A698.4050707@linux.intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Dec 2014, Dave Hansen wrote:

> I sometimes wonder what 'numa_maps' purpose is any if we should have
> _some_ kind of policy about what goes in there vs. smaps.  numa_maps
> seems to be turning in to smaps, minus the \n. :)
> 

It seems like an interface, similar to the one proposed by Ulrich, that 
described the NUMA topology would have obsoleted numa_maps and you could 
only rely on smaps to determine locality.  There's existing userspace 
dependencies on numa_maps already, though, so owell.

I had to fix numa_maps output when autonuma was merged for a much more 
subtle difference at 
http://marc.info/?l=git-commits-head&m=139113691614467 so I know some 
people actually parse this and care quite a bit about its accuracy, it's a 
shame it can't be deprecated in favor of adding the necessary information 
to smaps.
