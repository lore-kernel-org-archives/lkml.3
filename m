Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966653Ab3DQOTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:19:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966409Ab3DQOTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:19:13 -0400
Date: Wed, 17 Apr 2013 07:19:09 -0700
From: Michal Hocko <mhocko@suse.cz>
To: Han Pingtian <hanpt@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Subject: Re: OOM-killer and strange RSS value in 3.9-rc7
Message-ID: <20130417141909.GA24912@dhcp22.suse.cz>
References: <20130416110009.GA2664@localhost.localdomain>
 <alpine.DEB.2.02.1304161315290.30779@chino.kir.corp.google.com>
 <20130417094750.GB2672@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130417094750.GB2672@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 17-04-13 17:47:50, Han Pingtian wrote:
> [ 5233.949714] Node 1 DMA free:3968kB min:7808kB low:9728kB high:11712kB active_anon:0kB inactive_anon:3584kB active_file:2240kB inactive_file:576kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:4194304kB managed:3854464kB mlocked:0kB dirty:64kB writeback:448kB mapped:0kB shmem:64kB slab_reclaimable:106496kB slab_unreclaimable:3654976kB kernel_stack:14912kB pagetables:18496kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:531 all_unreclaimable? yes

This smells either like a slab backed memory leak or something went
crazy and allocate huge amount of slab. You have 3.6G (or of 4G
available) of slab_unreclaimable. I would check /proc/slabinfo for which
cache consumes that huge amount of memory.
-- 
Michal Hocko
SUSE Labs
