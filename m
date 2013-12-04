Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab3LDP0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:26:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932448Ab3LDP0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:26:39 -0500
Date: Wed, 4 Dec 2013 07:27:43 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Adrien =?iso-8859-1?Q?Verg=E9?= <adrienverge@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Will Deacon <will.deacon@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 3/3] ARM Coresight: Add PID control support for ETM
 tracing
Message-ID: <20131204152743.GC12847@kroah.com>
References: <CANsc=4Vy911xcf7fYEjyeV_CNGp8POje9BZrLSP8xrk4YAfSNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANsc=4Vy911xcf7fYEjyeV_CNGp8POje9BZrLSP8xrk4YAfSNA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 11:40:59PM -0500, Adrien Vergé wrote:
> @@ -616,7 +670,7 @@ static int etm_probe(struct amba_device *dev,
> const struct amba_id *id)
>   if (ret)
>   goto out_unmap;
> 
> - /* failing to create any of these three is not fatal */
> + /* failing to create any of these four is not fatal */
>   ret = sysfs_create_file(&dev->dev.kobj, &trace_info_attr.attr);
>   if (ret)
>   dev_dbg(&dev->dev, "Failed to create trace_info in sysfs\n");
> @@ -629,6 +683,10 @@ static int etm_probe(struct amba_device *dev,
> const struct amba_id *id)
>   if (ret)
>   dev_dbg(&dev->dev, "Failed to create trace_addrrange in sysfs\n");
> 
> + ret = sysfs_create_file(&dev->dev.kobj, &trace_pid_attr.attr);
> + if (ret)
> + dev_dbg(&dev->dev, "Failed to create trace_pid in sysfs\n");
> +
>   dev_dbg(t->dev, "ETM AMBA driver initialized.\n");
> 
>  out:

Again, not your fault, but you just raced with userspace, so now
userspace can't see your device files at all.  Please use the correct
api for this (groups), and actually, it should all be using debugfs if
anything, not sysfs at all.

thanks,

greg k-h
