Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680Ab3KSC5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 21:57:40 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:15525 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab3KSC5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 21:57:38 -0500
Message-ID: <528AD316.10001@huawei.com>
Date: Tue, 19 Nov 2013 10:55:18 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Shawn Bohrer <shawn.bohrer@gmail.com>
CC: Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@suse.cz>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Markus Blank-Burian <burian@muenster.de>
Subject: Re: 3.10.16 cgroup_mutex deadlock
References: <20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com> <52820030.6000806@huawei.com> <20131112143147.GB6049@dhcp22.suse.cz> <20131112155530.GA2860@sbohrermbp13-local.rgmadvisors.com> <20131112165504.GF6049@dhcp22.suse.cz> <20131114225649.GA16725@sbohrermbp13-local.rgmadvisors.com> <20131115062458.GA9755@mtj.dyndns.org> <20131115075401.GB9755@mtj.dyndns.org> <alpine.LNX.2.00.1311171746160.15789@eggly.anvils> <20131118201025.GA2747@sbohrermbp13-local.rgmadvisors.com>
In-Reply-To: <20131118201025.GA2747@sbohrermbp13-local.rgmadvisors.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks Tejun and Hugh.  Sorry for my late entry in getting around to
> testing this fix. On the surface it sounds correct however I'd like to
> test this on top of 3.10.* since that is what we'll likely be running.
> I've tried to apply Hugh's patch above on top of 3.10.19 but it
> appears there are a number of conflicts.  Looking over the changes and
> my understanding of the problem I believe on 3.10 only the
> cgroup_free_fn needs to be run in a separate workqueue.  Below is the
> patch I've applied on top of 3.10.19, which I'm about to start
> testing.  If it looks like I botched the backport in any way please
> let me know so I can test a propper fix on top of 3.10.19.
> 

You didn't move css free_work to the dedicate wq as Tejun's patch does.
css free_work won't acquire cgroup_mutex, but when destroying a lot of
cgroups, we can have a lot of css free_work in the workqueue, so I'd
suggest you also use cgroup_destroy_wq for it.


