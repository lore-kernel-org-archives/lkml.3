Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab3HUOIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:08:52 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:42192 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab3HUOIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:08:50 -0400
Date: Wed, 21 Aug 2013 10:08:46 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 08/11] cpuset: separate configured masks and efffective
 masks
Message-ID: <20130821140846.GH19286@mtj.dyndns.org>
References: <52148F52.0@huawei.com>
 <52148FCA.8010704@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52148FCA.8010704@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 06:00:42PM +0800, Li Zefan wrote:
> @@ -2261,7 +2271,8 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
>  	/* synchronize mems_allowed to N_MEMORY */
>  	if (mems_updated) {
>  		mutex_lock(&callback_mutex);
> -		top_cpuset.mems_allowed = new_mems;
> +		if (!sane)
> +			top_cpuset.mems_allowed = new_mems;

Can you please further explain how the top cgroup behaves?

-- 
tejun
