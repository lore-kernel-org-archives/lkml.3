Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289Ab3BLWNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:13:22 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:60213 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757948Ab3BLWNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:13:21 -0500
Date: Tue, 12 Feb 2013 14:13:15 -0800
From: Tejun Heo <tj@kernel.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: compositing broken in -next (idr bug)
Message-ID: <20130212221315.GC9057@htj.dyndns.org>
References: <511ABA59.9050604@suse.cz>
 <511ABC32.3050706@suse.cz>
 <511ABD69.3060201@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511ABD69.3060201@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jiri.

On Tue, Feb 12, 2013 at 11:08:41PM +0100, Jiri Slaby wrote:
> > Oh my, maybe: return ret < 0 ? ret : 0... Let's try.
> 
> Bull's eye.

Aieee....

> --- a/drivers/gpu/drm/drm_gem.c
> +++ b/drivers/gpu/drm/drm_gem.c
> @@ -459,6 +459,7 @@ drm_gem_flink_ioctl(struct drm_device *dev, void *data,
> 
>                 if (ret < 0)
>                         goto err;
> +               ret = 0;
> 
>                 /* Allocate a reference for the name table.  */
>                 drm_gem_object_reference(obj);

Care to write up a proper patch w/ SOB?

Thanks!

-- 
tejun
