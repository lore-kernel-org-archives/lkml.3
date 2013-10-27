Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab3J0LaZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 07:30:25 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:58114 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab3J0LaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 07:30:24 -0400
Date: Sun, 27 Oct 2013 07:30:20 -0400
From: Tejun Heo <tj@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: gregkh@linuxfoundation.org, kay@vrfy.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, bhelgaas@google.com
Subject: Re: [PATCH 14/34] sysfs, kernfs: prepare read path for kernfs
Message-ID: <20131027113020.GD14934@mtj.dyndns.org>
References: <1382629780-10006-1-git-send-email-tj@kernel.org>
 <1382629780-10006-15-git-send-email-tj@kernel.org>
 <20131026113221.GB1792@Nokia-N900>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131026113221.GB1792@Nokia-N900>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 01:32:21PM +0200, Pavel Machek wrote:
> Hi!
> 
> > We're in the process of separating out core sysfs functionality into
> > kernfs which will deal with sysfs_dirents directly.  This patch
> > rearranges read path so that the kernfs and sysfs parts are separate.
> 
> > +static int sysfs_kf_seq_show(struct seq_file *sf, void *v)
> >  {
> >  	struct sysfs_open_file *of = sf->private;
> >  	struct kobject *kobj = of->sd->s_parent->priv;
> > -	const struct sysfs_ops *ops;
> > +	const struct sysfs_ops *ops = sysfs_file_ops(of->sd);
> > +	ssize_t count = 0;
> >  	char *buf;
> > -	ssize_t count;
> >  
> >  	/* acquire buffer and ensure that it's >= PAGE_SIZE */
> >  	count = seq_get_buf(sf, &buf);
> 
> Initing count to zero is superfluous here.

Ooh, right.

> > +	/* the same behavior as single_open() */
> > +	return NULL + !*ppos;
> > +}
> 
> That's certainly interesting code.

Directly copied from single_*() functions.  Will add some comments but
what it's doing is inherently slightly tricky.

Thanks.

-- 
tejun
