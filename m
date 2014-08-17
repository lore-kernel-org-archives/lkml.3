Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729AbaHQNmG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 09:42:06 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:61514 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaHQNmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 09:42:05 -0400
Date: Sun, 17 Aug 2014 09:41:59 -0400
From: Tejun Heo <tj@kernel.org>
To: Alban Crequy <alban.crequy@collabora.co.uk>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] [RFC] cgroup: reject cgroup names with non-printing
 characters
Message-ID: <20140817134159.GE7679@mtj.dyndns.org>
References: <1405955516-22016-1-git-send-email-alban.crequy@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405955516-22016-1-git-send-email-alban.crequy@collabora.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alban.

Sorry about the delay.

On Mon, Jul 21, 2014 at 04:11:56PM +0100, Alban Crequy wrote:
> @@ -4387,6 +4401,11 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
>  	struct kernfs_node *kn;
>  	int ssid, ret;
>  
> +	/* do not create cgroups with bad names */
> +	ret = cgroup_is_used_badchars(name);
> +	if (ret)
> +		return ret;

Let's just reject '\n'.  That should give us a way to parse the path
correctly and I don't want to put more-than-necessary interpretation
on the path string.

Thanks.

-- 
tejun
