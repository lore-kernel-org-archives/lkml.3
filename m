Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab3JQOO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:14:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab3JQOOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:14:24 -0400
Date: Thu, 17 Oct 2013 07:15:34 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>, Sudeep Dutt <sudeep.dutt@intel.com>
Subject: Re: [PATCH -next] misc: fix various misc/mic/host/ build errors
Message-ID: <20131017141534.GA22319@kroah.com>
References: <1381762088-18880-1-git-send-email-treding@nvidia.com>
 <525C481E.1010908@infradead.org>
 <20131016192648.GA19637@kroah.com>
 <525EEBD4.7070800@infradead.org>
 <20131016194440.GA14416@kroah.com>
 <20131016203024.GA6579@mithrandir>
 <20131016203727.GB1633@kroah.com>
 <20131017140224.GA32734@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017140224.GA32734@ulmo.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 04:02:25PM +0200, Thierry Reding wrote:
> On Wed, Oct 16, 2013 at 01:37:27PM -0700, Greg Kroah-Hartman wrote:
> > On Wed, Oct 16, 2013 at 10:30:25PM +0200, Thierry Reding wrote:
> > > On Wed, Oct 16, 2013 at 12:44:40PM -0700, Greg Kroah-Hartman wrote:
> > > > On Wed, Oct 16, 2013 at 12:41:08PM -0700, Randy Dunlap wrote:
> > > > > On 10/16/13 12:26, Greg Kroah-Hartman wrote:
> > > > > > On Mon, Oct 14, 2013 at 12:38:06PM -0700, Randy Dunlap wrote:
> > > > > >> From: Randy Dunlap <rdunlap@infradead.org>
> > > > > >>
> > > > > >> Fix various build errors (on x86_64) for drivers/misc/mic/host/:
> > > > > >>
> > > > > >>   drivers/misc/mic/host/mic_main.c:378:3: error: too many arguments to function 'sysfs_get_dirent'
> > > > > >>   drivers/misc/mic/host/mic_intr.h:134:58: warning: 'struct pci_dev' declared inside parameter list [enabled by default]
> > > > > >>   drivers/misc/mic/host/mic_intr.h:134:58: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
> > > > > >>   drivers/misc/mic/host/mic_intr.h:135:58: warning: 'struct pci_dev' declared inside parameter list [enabled by default]
> > > > > >>   drivers/misc/mic/host/mic_device.h:169:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]
> > > > > >>   drivers/misc/mic/host/mic_device.h: In function 'mic_mmio_read':
> > > > > >>   drivers/misc/mic/host/mic_device.h:169:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]
> > > > > >>   drivers/misc/mic/host/mic_device.h: In function 'mic_mmio_write':
> > > > > >>   drivers/misc/mic/host/mic_device.h:183:2: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]
> > > > > >>
> > > > > >> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > > > > >> Cc: Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>
> > > > > >> Cc: Ashutosh Dixit <ashutosh.dixit@intel.com>
> > > > > >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > >> Cc: Nikhil Rao <nikhil.rao@intel.com>
> > > > > >> Cc: Sudeep Dutt <sudeep.dutt@intel.com>
> > > > > > 
> > > > > > This is a -next issue only at this point in time, I thought it was in
> > > > > > the -next tree as a "fixup" already?
> > > > > 
> > > > > Are you asking the driver maintainers?
> > > > 
> > > > No, the linux-next maintainers.
> > > > 
> > > > The driver maintainers have nothing to do with this, it's a sysfs change
> > > > in my driver-core tree that causes this issue.
> > > 
> > > Well, we do carry a patch to fix this, but that generally doesn't get
> > > carried to Linus' tree automatically as far as I know. So I guess it's
> > > fine for now, but when the merge window opens you'll need to make sure
> > > that Linus merges the branches in the correct order so that the build
> > > doesn't break in between.
> > 
> > Yes, I'll do that as part of my normal tree submission process.
> 
> Actually, ensuring correct merge order won't be enough, will it? That
> doesn't magically fixes that the function's signature actually changed.
> 
> Shouldn't the update of the sysfs_get_dirent() call be fixed within the
> same patch that updates the sysfs_get_dirent() signature?

Yes, _if_ those files are actually part of that tree, but they aren't
(they got added in my staging-next tree, while these sysfs changes are
in my driver-next tree.)

So the trees on their own build just fine, it's only when you merge them
that there is an issue.  This happens all the time when apis change,
nothing new here...

greg k-h
