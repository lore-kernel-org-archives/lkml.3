Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab3H1OAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 10:00:06 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:58263 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab3H1OAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:00:04 -0400
Date: Wed, 28 Aug 2013 10:00:00 -0400
From: Tejun Heo <tj@kernel.org>
To: Jan Kaluza <jkaluza@redhat.com>
Cc: davem@davemloft.net, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, eparis@redhat.com, rgb@redhat.com
Subject: Re: [PATCH 3/3] Send cgroup_path in SCM_CGROUP
Message-ID: <20130828140000.GB9295@htj.dyndns.org>
References: <1377614400-27122-1-git-send-email-jkaluza@redhat.com>
 <1377614400-27122-4-git-send-email-jkaluza@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377614400-27122-4-git-send-email-jkaluza@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jan.

Can you please cc cgroup maintainers and mailing lists from
MAINTAINERS for cgroup related changes?

On Tue, Aug 27, 2013 at 04:40:00PM +0200, Jan Kaluza wrote:

Also, please describe what change is being made why on each patch.
Repeating the same description is fine but each patch descrption
should be more or less self-sufficient.

> +int scm_get_current_cgroup_path(char **cgroup_path)
> +{
> +	int ret = 0;
> +
> +	*cgroup_path = kmalloc(PAGE_SIZE, GFP_KERNEL);

PATH_MAX?

> +	if (!(*cgroup_path))
> +		return -ENOMEM;
> +
> +	ret = task_cgroup_path(current, *cgroup_path, PAGE_SIZE);
> +	if (ret < 0) {
> +		kfree(*cgroup_path);
> +		*cgroup_path = NULL;
> +	}
> +
> +	return ret;
> +}

Other than that, cgroup side looks fine to me.  For cgroup bits,

  Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
