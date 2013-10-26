Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab3JZLc0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 07:32:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59662 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab3JZLcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 07:32:25 -0400
Date: Sat, 26 Oct 2013 13:32:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tejun Heo <tj@kernel.org>
Cc: gregkh@linuxfoundation.org, kay@vrfy.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, bhelgaas@google.com
Subject: Re: [PATCH 14/34] sysfs, kernfs: prepare read path for kernfs
Message-ID: <20131026113221.GB1792@Nokia-N900>
References: <1382629780-10006-1-git-send-email-tj@kernel.org>
 <1382629780-10006-15-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382629780-10006-15-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> We're in the process of separating out core sysfs functionality into
> kernfs which will deal with sysfs_dirents directly.  This patch
> rearranges read path so that the kernfs and sysfs parts are separate.

> +static int sysfs_kf_seq_show(struct seq_file *sf, void *v)
>  {
>  	struct sysfs_open_file *of = sf->private;
>  	struct kobject *kobj = of->sd->s_parent->priv;
> -	const struct sysfs_ops *ops;
> +	const struct sysfs_ops *ops = sysfs_file_ops(of->sd);
> +	ssize_t count = 0;
>  	char *buf;
> -	ssize_t count;
>  
>  	/* acquire buffer and ensure that it's >= PAGE_SIZE */
>  	count = seq_get_buf(sf, &buf);

Initing count to zero is superfluous here.

> +	/* the same behavior as single_open() */
> +	return NULL + !*ppos;
> +}

That's certainly interesting code.

						Pavel
