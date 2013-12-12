Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab3LLXd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 18:33:56 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:63287 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab3LLXdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 18:33:55 -0500
Date: Fri, 13 Dec 2013 02:31:25 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: David Airlie <airlied@linux.ie>, Jerome Glisse <jglisse@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] radeon_pm: fix oops in hwmon_attributes_visible() and
 radeon_hwmon_show_temp_thresh()
Message-ID: <20131212233125.GB2203@swordfish>
References: <20131212232557.GA2203@swordfish>
 <A3397C8B8B789E45844E7EC5DEAD89D030AA1DFB@satlexdag05.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A3397C8B8B789E45844E7EC5DEAD89D030AA1DFB@satlexdag05.amd.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (12/12/13 23:29), Deucher, Alexander wrote:
> Fix is already queued in my next -fixes pull.  Thanks!
> 

Nice. Thanks!

	-ss

> Alex
> 
> > -----Original Message-----
> > From: Sergey Senozhatsky [mailto:sergey.senozhatsky@gmail.com]
> > Sent: Thursday, December 12, 2013 6:26 PM
> > To: Deucher, Alexander
> > Cc: David Airlie; Jerome Glisse; dri-devel@lists.freedesktop.org; linux-
> > kernel@vger.kernel.org
> > Subject: [PATCH] radeon_pm: fix oops in hwmon_attributes_visible() and
> > radeon_hwmon_show_temp_thresh()
> > 
> > Since ec39f64bba radeon_hwmon_init() is using
> > hwmon_device_register_with_groups(), which sets `rdev' as a device
> > private driver_data, while hwmon_attributes_visible() and
> > radeon_hwmon_show_temp_thresh() are still waiting for `drm_device'.
> > fix them by using dev_get_drvdata():
> > 
> > BUG: unable to handle kernel paging request at 0000000000001e28
> > IP: [<ffffffffa02ae8b4>] hwmon_attributes_visible+0x18/0x3d [radeon]
> > PGD 15057e067 PUD 151a8e067 PMD 0
> > Oops: 0000 [#1] PREEMPT SMP
> > Call Trace:
> >  [<ffffffff81163ba7>] internal_create_group+0x114/0x1d9
> >  [<ffffffff81163c7a>] sysfs_create_group+0xe/0x10
> >  [<ffffffff81163ec7>] sysfs_create_groups+0x22/0x5f
> >  [<ffffffff812ceed8>] device_add+0x34f/0x501
> >  [<ffffffff812cf09f>] device_register+0x15/0x18
> >  [<ffffffff81317e5e>] hwmon_device_register_with_groups+0xb5/0xed
> >  [<ffffffffa02aec00>] radeon_hwmon_init+0x56/0x7c [radeon]
> >  [<ffffffffa02b020b>] radeon_pm_init+0x134/0x7e5 [radeon]
> >  [<ffffffff810f5c7c>] ? kmem_cache_alloc+0x63/0xe3
> >  [<ffffffffa0284ed1>] radeon_modeset_init+0x75f/0x8ed [radeon]
> >  [<ffffffffa02671b6>] radeon_driver_load_kms+0xc6/0x187 [radeon]
> >  [<ffffffffa021cb33>] drm_dev_register+0xf9/0x1b4 [drm]
> >  [<ffffffffa021ddf2>] drm_get_pci_dev+0x98/0x129 [drm]
> >  [<ffffffff810f602e>] ? kfree+0x10a/0x166
> >  [<ffffffffa0264345>] ? radeon_pci_probe+0x91/0xac [radeon]
> >  [<ffffffffa0264357>] radeon_pci_probe+0xa3/0xac [radeon]
> >  [<ffffffff8125b90c>] pci_device_probe+0x6e/0xcf
> >  [<ffffffff812d13e4>] driver_probe_device+0x98/0x1c4
> >  [<ffffffff812d15a4>] __driver_attach+0x5c/0x7e
> >  [<ffffffff812d1548>] ? __device_attach+0x38/0x38
> >  [<ffffffff812cfac9>] bus_for_each_dev+0x7b/0x85
> >  [<ffffffff812d0f69>] driver_attach+0x19/0x1b
> >  [<ffffffff812d0c27>] bus_add_driver+0x104/0x1ce
> >  [<ffffffff812d1b23>] driver_register+0x89/0xc5
> >  [<ffffffff8125b033>] __pci_register_driver+0x58/0x5b
> >  [<ffffffffa037f000>] ? 0xffffffffa037efff
> >  [<ffffffffa021df09>] drm_pci_init+0x86/0xea [drm]
> >  [<ffffffffa037f000>] ? 0xffffffffa037efff
> >  [<ffffffffa037f097>] radeon_init+0x97/0x1000 [radeon]
> >  [<ffffffff81000290>] do_one_initcall+0x7f/0x117
> >  [<ffffffff810323bc>] ? set_memory_nx+0x3b/0x3d
> >  [<ffffffff810a002a>] load_module+0x1583/0x1bb4
> >  [<ffffffff8109d602>] ? store_uevent+0x35/0x35
> >  [<ffffffff8106121a>] ? finish_task_switch+0x3b/0x10c
> >  [<ffffffff813e818b>] ? preempt_schedule_irq+0x5d/0x99
> >  [<ffffffff813ecdf7>] ? retint_restore_args+0x13/0x13
> >  [<ffffffff810a06fb>] SyS_init_module+0xa0/0xaf
> >  [<ffffffff813ed7e6>] tracesys+0xd4/0xd9
> > 
> > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > 
> > ---
> > 
> >  drivers/gpu/drm/radeon/radeon_pm.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/radeon/radeon_pm.c
> > b/drivers/gpu/drm/radeon/radeon_pm.c
> > index dc75bb6..984097b 100644
> > --- a/drivers/gpu/drm/radeon/radeon_pm.c
> > +++ b/drivers/gpu/drm/radeon/radeon_pm.c
> > @@ -552,8 +552,7 @@ static ssize_t
> > radeon_hwmon_show_temp_thresh(struct device *dev,
> >  					     struct device_attribute *attr,
> >  					     char *buf)
> >  {
> > -	struct drm_device *ddev = dev_get_drvdata(dev);
> > -	struct radeon_device *rdev = ddev->dev_private;
> > +	struct radeon_device *rdev = dev_get_drvdata(dev);
> >  	int hyst = to_sensor_dev_attr(attr)->index;
> >  	int temp;
> > 
> > @@ -580,8 +579,7 @@ static umode_t hwmon_attributes_visible(struct
> > kobject *kobj,
> >  					struct attribute *attr, int index)
> >  {
> >  	struct device *dev = container_of(kobj, struct device, kobj);
> > -	struct drm_device *ddev = dev_get_drvdata(dev);
> > -	struct radeon_device *rdev = ddev->dev_private;
> > +	struct radeon_device *rdev = dev_get_drvdata(dev);
> > 
> >  	/* Skip limit attributes if DPM is not enabled */
> >  	if (rdev->pm.pm_method != PM_METHOD_DPM &&
> > 
> 
> 
