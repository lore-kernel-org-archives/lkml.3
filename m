Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172Ab3DCDwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 23:52:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59266 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750Ab3DCDwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 23:52:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130403030403.GA26913@redhat.com>
References: <1364957903-10341-1-git-send-email-ming.lei@canonical.com>
	<20130403030403.GA26913@redhat.com>
Date: Wed, 3 Apr 2013 11:52:39 +0800
Message-ID: <CACVXFVPOC=d3-1UBu6UbqJXMS2gG=DXnBJeuLaFc3R4QKAzWyg@mail.gmail.com>
Subject: Re: [PATCH] sysfs: check if one entry has been removed before freeing
From: Ming Lei <ming.lei@canonical.com>
To: Dave Jones <davej@redhat.com>, Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 3, 2013 at 11:04 AM, Dave Jones <davej@redhat.com> wrote:
> On Wed, Apr 03, 2013 at 10:58:23AM +0800, Ming Lei wrote:
>
>  > diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
>  > index 1bf016b..328ef9b 100644
>  > --- a/fs/sysfs/dir.c
>  > +++ b/fs/sysfs/dir.c
>  > @@ -268,6 +268,13 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
>  >       */
>  >      parent_sd = sd->s_parent;
>  >
>  > +    if (unlikely(!(sd->s_flags & SYSFS_FLAG_REMOVED))) {
>  > +            printk(KERN_ERR "sysfs: free using entry: %s/%s\n",
>  > +                    parent_sd ? parent_sd->s_name : "",
>  > +                    sd->s_name);
>  > +            BUG();
>  > +    }
>
> Please use WARN instead of BUG.  For an in-ram filesystem like
> sysfs, there's no real reason to lock-up the machine in this way
> making it harder to debug.

If WARN is used, the freed memory will be allocated to other
kernel components, then sysfs may change the memory and cause
destruction, so maybe it is better to use BUG to stop kernel.

Thanks,
--
Ming Lei
