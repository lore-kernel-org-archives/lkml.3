Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbaDOMyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:54:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754638AbaDOMx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:53:57 -0400
Date: Tue, 15 Apr 2014 13:53:25 +0100
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: tj@kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: print pretty format in /proc/cgroups
Message-ID: <20140415125325.GH13914@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <1397566065-3028-1-git-send-email-nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1397566065-3028-1-git-send-email-nasa4836@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 08:47:45PM +0800, Jianyu Zhan wrote:
> I found that /proc/cgroups printed format has ugly alignment(see below).

[snip]

> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 9fcdaa7..d981697 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -4347,7 +4347,7 @@ static int proc_cgroupstats_show(struct seq_file *m, void *v)
>  	mutex_lock(&cgroup_mutex);
>  
>  	for_each_subsys(ss, i)
> -		seq_printf(m, "%s\t%d\t%d\t%d\n",
> +		seq_printf(m, "%-16s%-16d%-16d%-16d\n",
>  			   ss->name, ss->root->hierarchy_id,
>  			   atomic_read(&ss->root->nr_cgrps), !ss->disabled);

This is liable to break userspace apps which might currently parse the
file by splitting on '\t'

Regards,
Daniel
-- 
|: http://berrange.com      -o-    http://www.flickr.com/photos/dberrange/ :|
|: http://libvirt.org              -o-             http://virt-manager.org :|
|: http://autobuild.org       -o-         http://search.cpan.org/~danberr/ :|
|: http://entangle-photo.org       -o-       http://live.gnome.org/gtk-vnc :|
