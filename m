Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915Ab3HNQsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:48:46 -0400
Received: from a9-58.smtp-out.amazonses.com ([54.240.9.58]:49022 "EHLO
	a9-58.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932831Ab3HNQsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:48:45 -0400
X-Greylist: delayed 719 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Aug 2013 12:48:45 EDT
Date: Wed, 14 Aug 2013 16:36:44 +0000
From: Christoph Lameter <cl@gentwo.org>
To: Minchan Kim <minchan@kernel.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, k.kozlowski@samsung.com,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, guz.fnst@cn.fujitsu.com,
        Benjamin LaHaise <bcrl@kvack.org>, Dave Hansen <dave.hansen@intel.com>,
        lliubbo@gmail.com, aquini@redhat.com, Rik van Riel <riel@redhat.com>
Subject: Re: [RFC 0/3] Pin page control subsystem
In-Reply-To: <20130814001236.GC2271@bbox>
Message-ID: <000001407dafbe92-7b2b4006-2225-4f0b-b23b-d66101a995aa-000000@email.amazonses.com>
References: <1376377502-28207-1-git-send-email-minchan@kernel.org> <00000140787b6191-ae3f2eb1-515e-48a1-8e64-502772af4700-000000@email.amazonses.com> <20130814001236.GC2271@bbox>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.08.14-54.240.9.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Aug 2013, Minchan Kim wrote:

> On Tue, Aug 13, 2013 at 04:21:30PM +0000, Christoph Lameter wrote:
> > On Tue, 13 Aug 2013, Minchan Kim wrote:
> >
> > > VM sometime want to migrate and/or reclaim pages for CMA, memory-hotplug,
> > > THP and so on but at the moment, it could handle only userspace pages
> > > so if above example subsystem have pinned a some page in a range VM want
> > > to migrate, migration is failed so above exmaple couldn't work well.
> >
> > Dont we have the mmu_notifiers that could help in that case? You could get
> > a callback which could prepare the pages for migration?
>
> Now I'm not familiar with mmu_notifier so please could you elaborate it
> a bit for me to dive into that?

Add a notifier callback for unpinning pages to the mmu notifier subsystem
and then your drivers could register with the subsystem to get
notifications when migration needs to occur etc.

