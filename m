Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbaBKPm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:42:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbaBKPmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:42:25 -0500
Date: Tue, 11 Feb 2014 10:10:27 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mtosatti@redhat.com,
        mgorman@suse.de, aarcange@redhat.com, andi@firstfloor.org,
        riel@redhat.com
Subject: Re: [PATCH 0/4] hugetlb: add hugepagesnid= command-line option
Message-ID: <20140211101027.5e32f1c2@redhat.com>
In-Reply-To: <20140210151354.68fe414f81335d4ce0e4c550@linux-foundation.org>
References: <1392053268-29239-1-git-send-email-lcapitulino@redhat.com>
	<20140210151354.68fe414f81335d4ce0e4c550@linux-foundation.org>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Feb 2014 15:13:54 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 10 Feb 2014 12:27:44 -0500 Luiz Capitulino <lcapitulino@redhat.com> wrote:
> 
> > HugeTLB command-line option hugepages= allows the user to specify how many
> > huge pages should be allocated at boot. On NUMA systems, this argument
> > automatically distributes huge pages allocation among nodes, which can
> > be undesirable.
> 
> Grumble.  "can be undesirable" is the entire reason for the entire
> patchset.  We need far, far more detail than can be conveyed in three
> words, please!

Right, sorry for that. I'll improve this for v2, but a better introduction
for the series would be something like the following.

Today, HugeTLB provides support for controlling allocation of persistent
huge pages on a NUMA system through sysfs. So, for example, if a sysadmin
wants to allocate 300 2M huge pages on node 1, s/he can do:

 echo 300 > /sys/devices/system/node/node1/hugepages/hugepages-2048kB/nr_hugepages

This works as long as you have enough contiguous pages, which may work
for 2M pages, but is harder for 1G huge pages. For those, it's better or even
required to reserve them at boot.

To this end we have the hugepages= command-line option, which works but misses
the per node control. This option evenly distributes huge pages among nodes.
However, we have users who want more flexibility. They want to be able to
specify something like: allocate 2 1G huge pages from node0 and 4 1G huge page
from node1. This is what this series implements.

It's basically per node allocation control for 1G huge pages, but it's
important to note that this series is not intrusive. All it does is to set
the initial per node allocation. All the functions and data structure added
by this series are only used once at boot, after that they are discarded and
rest in oblivion.
