Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbaA3QmC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 11:42:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbaA3QmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 11:42:01 -0500
Date: Thu, 30 Jan 2014 11:41:51 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: daniel.vetter@ffwll.ch, airlied@redhat.com
Subject: Re: drm: restrict the device list for shadow attached drivers
Message-ID: <20140130164151.GA24574@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	daniel.vetter@ffwll.ch, airlied@redhat.com
References: <20140130045754.7E5C1660D2B@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140130045754.7E5C1660D2B@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 04:57:54AM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/linus/;a=commit;h=b3f2333de8e81b089262b26d52272911523e605f
 > Commit:     b3f2333de8e81b089262b26d52272911523e605f
 > Parent:     e2577d455adb165e1046816e5ed092cc6d60f35a
 > Author:     Daniel Vetter <daniel.vetter@ffwll.ch>
 > AuthorDate: Wed Dec 11 11:34:31 2013 +0100
 > Committer:  Dave Airlie <airlied@redhat.com>
 > CommitDate: Wed Dec 18 11:08:36 2013 +1000
 > 
 >     drm: restrict the device list for shadow attached drivers
 
 > @@ -465,8 +470,11 @@ void drm_pci_exit(struct drm_driver *driver, struct pci_driver *pdriver)
 >  	if (driver->driver_features & DRIVER_MODESET) {
 >  		pci_unregister_driver(pdriver);
 >  	} else {
 > -		list_for_each_entry_safe(dev, tmp, &driver->device_list, driver_item)
 > +		list_for_each_entry_safe(dev, tmp, &driver->legacy_dev_list,
 > +					 legacy_dev_list) {
 >  			drm_put_dev(dev);
 > +			list_del(&dev->legacy_dev_list);
 > +		}
 >  	}

Use-after-free.  drm_put_dev frees dev.

	Dave

