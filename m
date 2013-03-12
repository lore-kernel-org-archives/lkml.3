Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab3CLP2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 11:28:31 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:45601
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755554Ab3CLP2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 11:28:30 -0400
Message-ID: <1363102105.24558.4.camel@laptop>
Subject: Re: [PATCH] device: separate all subsys mutexes (was: Re: [BUG]
 potential deadlock led by cpu_hotplug lock (memcg involved))
From: Peter Zijlstra <peterz@infradead.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>,
        cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Tue, 12 Mar 2013 16:28:25 +0100
In-Reply-To: <20130312130504.GD30758@dhcp22.suse.cz>
References: <513ECCFE.3070201@huawei.com>
	 <20130312101555.GB30758@dhcp22.suse.cz>
	 <20130312110750.GC30758@dhcp22.suse.cz>
	 <20130312130504.GD30758@dhcp22.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-12 at 14:05 +0100, Michal Hocko wrote:
> @@ -111,17 +111,17 @@ struct bus_type {
>         struct iommu_ops *iommu_ops;
>  
>         struct subsys_private *p;
> +       struct lock_class_key __key;
>  };

Is struct bus_type constrained to static storage or can people go an
allocate this stuff dynamically? If so, this patch is broken.

