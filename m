Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298Ab3HIBAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:00:39 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:36069 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758263Ab3HIBAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:00:36 -0400
Date: Thu, 8 Aug 2013 21:00:32 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Michal Hocko <mhocko@suse.cz>, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.12] cgroup: make cgroup_event specific to
 memcg
Message-ID: <20130809010032.GA14792@mtj.dyndns.org>
References: <20130805162958.GF19631@mtj.dyndns.org>
 <20130805191641.GA24003@dhcp22.suse.cz>
 <20130805194431.GD23751@mtj.dyndns.org>
 <20130806155804.GC31138@dhcp22.suse.cz>
 <20130806161509.GB10779@mtj.dyndns.org>
 <20130807121836.GF8184@dhcp22.suse.cz>
 <20130807124321.GA27006@htj.dyndns.org>
 <20130807132613.GH8184@dhcp22.suse.cz>
 <20130807133645.GE27006@htj.dyndns.org>
 <5203081C.8050403@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5203081C.8050403@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Thu, Aug 08, 2013 at 10:53:16AM +0800, Li Zefan wrote:
> I would like to see this happen. I have a feeling that we're deprecating
> features a bit aggressively without providing alternatives.

I'd rework it prolly next week but this has to go one way or another.
There's no way we're implementing userland interface this complex in
cgroup proper.  It is a gross layering violation.  We don't implement
userland visible interface this complex in low level subsystems.  It's
wrong both in principle and leads to all sorts of problems in practice
like ending up worrying about userland abuses in memcg event source
implementation, which is utterly bonkers if you ask me.

Thanks.

-- 
tejun
