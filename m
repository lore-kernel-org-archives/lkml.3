Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbaCLD4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 23:56:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:39055 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbaCLD4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 23:56:02 -0400
Message-ID: <1394596541.4840.70.camel@pasglop>
Subject: Re: linux-next: build failure after merge of the driver-core tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg KH <greg@kroah.com>
Cc: Mark Brown <broonie@kernel.org>,
        Stewart Smith <stewart@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 12 Mar 2014 14:55:41 +1100
In-Reply-To: <20140312015021.GC10106@kroah.com>
References: <20140312005152.9ac4063f65dbd233f5d50b4d@kernel.org>
	 <20140312015021.GC10106@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-11 at 18:50 -0700, Greg KH wrote:
> On Wed, Mar 12, 2014 at 12:51:52AM +0000, Mark Brown wrote:
> > Hi Greg,
> > 
> > After merging the driver-core tree, today's linux-next build ()
> > failed like this on a PowerPC defconfig:
> > 
> > HEAD is now at ceb98e684dec Merge remote-tracking branch 'driver-core/driver-core-next'
> >   GEN     /home/broonie/next/powerpc_ppc64_defconfig/Makefile
> > #
> > # configuration written to .config
> > #
> > /home/broonie/next/next/arch/powerpc/platforms/powernv/opal-elog.c: In function 'elog_ack_store':
> > /home/broonie/next/next/arch/powerpc/platforms/powernv/opal-elog.c:84:2: error: implicit declaration of function 'sysfs_schedule_callback' [-Werror=implicit-function-declaration]
> >   sysfs_schedule_callback(&elog_obj->kobj, delay_release_kobj,
> >   ^
> > cc1: all warnings being treated as errors
> > make[3]: *** [arch/powerpc/platforms/powernv/opal-elog.o] Error 1
> > make[3]: *** Waiting for unfinished jobs....
> > /home/broonie/next/next/arch/powerpc/platforms/powernv/opal-dump.c: In function 'dump_ack_store':
> > /home/broonie/next/next/arch/powerpc/platforms/powernv/opal-dump.c:100:2: error: implicit declaration of function 'sysfs_schedule_callback' [-Werror=implicit-function-declaration]
> >   sysfs_schedule_callback(&dump_obj->kobj, delay_release_kobj,
> >   ^
> > cc1: all warnings being treated as errors
> > 
> > due to an interaction between d1ba277e7988908 (sysfs, driver-core: remove unused {sysfs|device}_schedule_callback_owner()) and 774fea1a38c6a5a8 (powerpc/powernv: Read OPAL error log and export it through sysfs) from the PowerPC tree.
> > 
> > I reverted 774fea1a38c6a5a8 for today.
> 
> Sounds like the powerpc tree also needs to stop using this function :)

powerpc -next is a never-rebase branch, so we are somewhat stuffed here.

How do you suggest we proceed ? I can't add a fix to powerpc-next to use
the new function since it doesn't exist upstream yet. I would have to
pull drivers-core-next in which I really don't want to do....

Can the removal of the function be delayed to -rc1 so we can properly
do the fixup ? Or do you have the introduction of the new function in
a topic branch I can pull in without the rest of drivers-core-next ?

Cheers,
Ben.


