Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbaDRUFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 16:05:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42213 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbaDRUFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 16:05:45 -0400
Date: Fri, 18 Apr 2014 13:05:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Robert Haas <robertmhaas@gmail.com>, Josh Berkus <josh@agliodbs.com>,
        Andres Freund <andres@2ndquadrant.com>,
        Christoph Lameter <cl@linux.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 0/2] Disable zone_reclaim_mode by default v2
Message-Id: <20140418130543.8619064c0e5d26cd914c4c3c@linux-foundation.org>
In-Reply-To: <1396945380-18592-1-git-send-email-mgorman@suse.de>
References: <1396945380-18592-1-git-send-email-mgorman@suse.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Apr 2014 09:22:58 +0100 Mel Gorman <mgorman@suse.de> wrote:

> Changelog since v1
>  o topology comment updates
> 
> When it was introduced, zone_reclaim_mode made sense as NUMA distances
> punished and workloads were generally partitioned to fit into a NUMA
> node. NUMA machines are now common but few of the workloads are NUMA-aware
> and it's routine to see major performance due to zone_reclaim_mode being
> enabled but relatively few can identify the problem.
> 
> Those that require zone_reclaim_mode are likely to be able to detect when
> it needs to be enabled and tune appropriately so lets have a sensible
> default for the bulk of users.
> 

This patchset conflicts with  

commit 70ef57e6c22c3323dce179b7d0d433c479266612
Author:     Michal Hocko <mhocko@suse.cz>
AuthorDate: Mon Apr 7 15:37:01 2014 -0700
Commit:     Linus Torvalds <torvalds@linux-foundation.org>
CommitDate: Mon Apr 7 16:35:50 2014 -0700

    mm: exclude memoryless nodes from zone_reclaim

It was pretty simple to resolve, but please check that I didn't miss
anything.
