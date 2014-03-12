Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbaCLBth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 21:49:37 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33611 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755835AbaCLBtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 21:49:35 -0400
X-Sasl-enc: CKCdrwxc+DWvH6MnAeCYEtYEICLvLIGSi9j5GxB8q7qB 1394588974
Date: Tue, 11 Mar 2014 18:50:21 -0700
From: Greg KH <greg@kroah.com>
To: Mark Brown <broonie@kernel.org>
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20140312015021.GC10106@kroah.com>
References: <20140312005152.9ac4063f65dbd233f5d50b4d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140312005152.9ac4063f65dbd233f5d50b4d@kernel.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 12:51:52AM +0000, Mark Brown wrote:
> Hi Greg,
> 
> After merging the driver-core tree, today's linux-next build ()
> failed like this on a PowerPC defconfig:
> 
> HEAD is now at ceb98e684dec Merge remote-tracking branch 'driver-core/driver-core-next'
>   GEN     /home/broonie/next/powerpc_ppc64_defconfig/Makefile
> #
> # configuration written to .config
> #
> /home/broonie/next/next/arch/powerpc/platforms/powernv/opal-elog.c: In function 'elog_ack_store':
> /home/broonie/next/next/arch/powerpc/platforms/powernv/opal-elog.c:84:2: error: implicit declaration of function 'sysfs_schedule_callback' [-Werror=implicit-function-declaration]
>   sysfs_schedule_callback(&elog_obj->kobj, delay_release_kobj,
>   ^
> cc1: all warnings being treated as errors
> make[3]: *** [arch/powerpc/platforms/powernv/opal-elog.o] Error 1
> make[3]: *** Waiting for unfinished jobs....
> /home/broonie/next/next/arch/powerpc/platforms/powernv/opal-dump.c: In function 'dump_ack_store':
> /home/broonie/next/next/arch/powerpc/platforms/powernv/opal-dump.c:100:2: error: implicit declaration of function 'sysfs_schedule_callback' [-Werror=implicit-function-declaration]
>   sysfs_schedule_callback(&dump_obj->kobj, delay_release_kobj,
>   ^
> cc1: all warnings being treated as errors
> 
> due to an interaction between d1ba277e7988908 (sysfs, driver-core: remove unused {sysfs|device}_schedule_callback_owner()) and 774fea1a38c6a5a8 (powerpc/powernv: Read OPAL error log and export it through sysfs) from the PowerPC tree.
> 
> I reverted 774fea1a38c6a5a8 for today.

Sounds like the powerpc tree also needs to stop using this function :)

thanks,

greg k-h
