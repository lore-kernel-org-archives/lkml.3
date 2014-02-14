Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbaBNWZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 17:25:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45819 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbaBNWZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 17:25:57 -0500
Date: Fri, 14 Feb 2014 14:27:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        B08248@freescale.com, kim.phillips@linaro.org, jan.kiszka@siemens.com,
        kvm@vger.kernel.org, R65777@freescale.com, B07421@freescale.com,
        christoffer.dall@linaro.org, agraf@suse.de, B16395@freescale.com,
        will.deacon@arm.com, Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Guenter Roeck <linux@roeck-us.net>, Toshi Kani <toshi.kani@hp.com>,
        Joe Perches <joe@perches.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Michal Hocko <mhocko@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [RFC PATCH v4 01/10] driver core: export driver_probe_device()
Message-ID: <20140214222716.GA11838@kroah.com>
References: <1391880580-471-1-git-send-email-a.motakis@virtualopensystems.com>
 <1391880580-471-2-git-send-email-a.motakis@virtualopensystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391880580-471-2-git-send-email-a.motakis@virtualopensystems.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 08, 2014 at 06:29:31PM +0100, Antonios Motakis wrote:
> From: Kim Phillips <kim.phillips@linaro.org>
> 
> Needed by drivers, such as the vfio platform driver [1], seeking to
> bypass bind_store()'s driver_match_device(), and bind to any device
> via a private sysfs bind file.
> 
> [1] https://lkml.org/lkml/2013/12/11/522
> 
> note: the EXPORT_SYMBOL is needed because vfio-platform can be built
> as a module.

No code outside of drivers/base/ should be calling this function, you
are doing something wrong in your bus if you want to do this, please fix
your bus code.

sorry, I can't accept this at all.

greg k-h
