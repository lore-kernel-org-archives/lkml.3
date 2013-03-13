Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933868Ab3CMPiC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 11:38:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46918 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391Ab3CMPiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 11:38:00 -0400
Date: Wed, 13 Mar 2013 16:37:58 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: linux-kernel mlist <linux-kernel@vger.kernel.org>,
        cgroups mailinglist <cgroups@vger.kernel.org>
Subject: Re: in.tftpd - ulimit -u not working? cgroups?
Message-ID: <20130313153758.GB13959@dhcp22.suse.cz>
References: <20130311144737.GA7024@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311144737.GA7024@pcnci.linuxbox.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 11-03-13 15:47:37, Nikola Ciprich wrote:
[...]
> I also tried limiting memory using cgroups, but even with limit of
> 2MB, it can spawn much more processes than I'd like, and 1MB is too
> low... 

If you were using memory cgroup then be aware that the controller covers
only user space allocations by default which doesn't prevent forks from
creating new processes.

> Is it possible to limit number of processes using cgroups?

You might be interested in KMEM (CONFIG_MEMCG_KMEM) extension for memory
cgroup (see Documentation/cgroups/memory.txt "2.7 Kernel Memory Extension
(CONFIG_MEMCG_KMEM)" for more information)
-- 
Michal Hocko
SUSE Labs
