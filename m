Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaCLTA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 15:00:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40052 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaCLTAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 15:00:24 -0400
Date: Wed, 12 Mar 2014 15:00:20 -0400 (EDT)
Message-Id: <20140312.150020.340861233360073600.davem@davemloft.net>
To: vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        netdev@vger.kernel.org, tj@kernel.org, ssorce@redhat.com,
        jkaluza@redhat.com, lpoetter@redhat.com, kay@redhat.com
Subject: Re: [PATCH 1/2] cgroup: Provide empty definition of
 task_cgroup_path()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394649942-5854-2-git-send-email-vgoyal@redhat.com>
References: <1394649942-5854-1-git-send-email-vgoyal@redhat.com>
	<1394649942-5854-2-git-send-email-vgoyal@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Mar 2014 12:00:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 12 Mar 2014 14:45:41 -0400

> Compilation with !CONFIG_CGROUP fails for task_cgroup_path() user. So
> provide an emtpy definition.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  include/linux/cgroup.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 9450f02..bf40adb 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -869,6 +869,8 @@ static inline int cgroup_attach_task_all(struct task_struct *from,
>  	return 0;
>  }
>  
> +static inline int task_cgroup_path(struct task_struct *task, char *buf, size_t buflen) {return 0;}
> +

Please properly format this just like any other function.

static inline int task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
{
	eturn 0;
}

It looked like a plain static declaration on first glance.
