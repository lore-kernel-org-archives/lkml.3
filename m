Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761826Ab3DCDEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 23:04:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761742Ab3DCDEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 23:04:10 -0400
Date: Tue, 2 Apr 2013 23:04:03 -0400
From: Dave Jones <davej@redhat.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH] sysfs: check if one entry has been removed before freeing
Message-ID: <20130403030403.GA26913@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ming Lei <ming.lei@canonical.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>
References: <1364957903-10341-1-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364957903-10341-1-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 10:58:23AM +0800, Ming Lei wrote:
 
 > diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
 > index 1bf016b..328ef9b 100644
 > --- a/fs/sysfs/dir.c
 > +++ b/fs/sysfs/dir.c
 > @@ -268,6 +268,13 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 >  	 */
 >  	parent_sd = sd->s_parent;
 >  
 > +	if (unlikely(!(sd->s_flags & SYSFS_FLAG_REMOVED))) {
 > +		printk(KERN_ERR "sysfs: free using entry: %s/%s\n",
 > +			parent_sd ? parent_sd->s_name : "",
 > +			sd->s_name);
 > +		BUG();
 > +	}

Please use WARN instead of BUG.  For an in-ram filesystem like
sysfs, there's no real reason to lock-up the machine in this way
making it harder to debug.

	Dave

