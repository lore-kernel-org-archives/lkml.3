Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbbADPlJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 10:41:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbbADPlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 10:41:05 -0500
Date: Sun, 4 Jan 2015 17:40:49 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        "open list:VIRTIO CORE, NET..." 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 2/2] virtio: don't free memory until the underlying
 struct device has been released
Message-ID: <20150104154049.GA6546@redhat.com>
References: <1420228060-18721-1-git-send-email-sasha.levin@oracle.com>
 <1420228060-18721-2-git-send-email-sasha.levin@oracle.com>
 <20150104112641.GB4336@redhat.com>
 <54A9563F.3070902@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A9563F.3070902@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2015 at 10:03:27AM -0500, Sasha Levin wrote:
> On 01/04/2015 06:26 AM, Michael S. Tsirkin wrote:
> > On Fri, Jan 02, 2015 at 02:47:40PM -0500, Sasha Levin wrote:
> >> > When releasing a virtio device, We can't free a struct virtio_device until the
> >> > underlying struct device has been released, which might not happen immediately
> >> > on device_unregister() even if that was the device's last reference.
> >> > 
> >> > Instead, free the memory only once we know the device is gone in the release
> >> > callback.
> >> > 
> >> > Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> > 
> > Isn't this an old bug: do we need to copy stable on a fix?
> > 
> > What is the behaviour without this patch?
> > Is there a way to make this cause a crash?
> 
> It will oops if CONFIG_DEBUG_KOBJECT_RELEASE is enabled. I guess
> it needs to go to stable as well.
> 
> 
> Thanks,
> Sasha

I see.

It's probably a good idea to document the crash in the commit log,
and also add a code comment.

I'll post the series with these minor tweaks, please confirm
that this fixes the issues for you.

-- 
MST
