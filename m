Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbaISLqD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:46:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756584AbaISLqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:46:00 -0400
Date: Fri, 19 Sep 2014 13:45:29 +0200
From: Karel Zak <kzak@redhat.com>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com,
        a.p.zijlstra@chello.nl, mingo@kernel.org, hpa@linux.intel.com,
        brice.goglin@gmail.com, bp@alien8.de
Subject: Re: [PATCH] x86: new topology for multi-NUMA-node CPUs
Message-ID: <20140919114529.GD5366@x2.net.home>
References: <20140918193334.C065EBCE@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140918193334.C065EBCE@viggo.jf.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 12:33:34PM -0700, Dave Hansen wrote:
> The sysfs effects here cause an issue with the hwloc tool where
> it gets confused and thinks there are more sockets than are
> physically present.
> 
> Before this patch, there are two packages:
> 
> # cd /sys/devices/system/cpu/
> # cat cpu*/topology/physical_package_id | sort | uniq -c
>      18 0
>      18 1
> 
> But 4 _sets_ of core siblings:
> 
> # cat cpu*/topology/core_siblings_list | sort | uniq -c
>       9 0-8
>       9 18-26
>       9 27-35
>       9 9-17
> 
> After this set, there are only 2 sets of core siblings, which
> is what we expect for a 2-socket system.
> 
> # cat cpu*/topology/physical_package_id | sort | uniq -c
>      18 0
>      18 1
> # cat cpu*/topology/core_siblings_list | sort | uniq -c
>      18 0-17
>      18 18-35

 hmm... it would be also nice to test it with lscpu(1) from 
 util-linux (but it uses maps rather than lists from cpu*/topology/).

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
