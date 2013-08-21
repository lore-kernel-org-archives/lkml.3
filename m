Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab3HUOUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:20:08 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:35690 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab3HUOUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:20:06 -0400
Date: Wed, 21 Aug 2013 10:20:01 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 11/11] cpuset: export effective masks to userspace
Message-ID: <20130821142001.GK19286@mtj.dyndns.org>
References: <52148F52.0@huawei.com>
 <52148FFC.4080701@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52148FFC.4080701@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 06:01:32PM +0800, Li Zefan wrote:
>  	{
> +		.name = "effective_cpus",
> +		.flags = CFTYPE_SANE,
> +		.read = cpuset_common_file_read,
> +		.max_write_len = (100U + 6 * NR_CPUS),
> +		.private = FILE_EFFECTIVE_CPULIST,

I don't think we need CFTYPE_SANE.  We can just expose these
unconditionally, right?  It still means the same thing when !sane.

Thanks.

-- 
tejun
