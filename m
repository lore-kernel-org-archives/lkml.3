Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975AbaCQSbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 14:31:38 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47290 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756060AbaCQSbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 14:31:35 -0400
X-Sasl-enc: JA8++rECgEUQ8NVs6MivwYU8/sCE9SteASVnDVocE9lV 1395081093
Date: Mon, 17 Mar 2014 11:33:33 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mark Brown <broonie@kernel.org>,
        Stewart Smith <stewart@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20140317183333.GE10565@kroah.com>
References: <20140312005152.9ac4063f65dbd233f5d50b4d@kernel.org>
 <20140312015021.GC10106@kroah.com>
 <20140317101611.d043a90e1cb72dcfb8bc767a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317101611.d043a90e1cb72dcfb8bc767a@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 10:16:11AM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Tue, 11 Mar 2014 18:50:21 -0700 Greg KH <greg@kroah.com> wrote:
> >
> > On Wed, Mar 12, 2014 at 12:51:52AM +0000, Mark Brown wrote:
> > > 
> > > After merging the driver-core tree, today's linux-next build ()
> > > failed like this on a PowerPC defconfig:
> > > 
> > > HEAD is now at ceb98e684dec Merge remote-tracking branch 'driver-core/driver-core-next'
> > >   GEN     /home/broonie/next/powerpc_ppc64_defconfig/Makefile
> > > #
> > > # configuration written to .config
> > > #
> > > /home/broonie/next/next/arch/powerpc/platforms/powernv/opal-elog.c: In function 'elog_ack_store':
> > > /home/broonie/next/next/arch/powerpc/platforms/powernv/opal-elog.c:84:2: error: implicit declaration of function 'sysfs_schedule_callback' [-Werror=implicit-function-declaration]
> > >   sysfs_schedule_callback(&elog_obj->kobj, delay_release_kobj,
> > >   ^
> > > cc1: all warnings being treated as errors
> > > make[3]: *** [arch/powerpc/platforms/powernv/opal-elog.o] Error 1
> > > make[3]: *** Waiting for unfinished jobs....
> > > /home/broonie/next/next/arch/powerpc/platforms/powernv/opal-dump.c: In function 'dump_ack_store':
> > > /home/broonie/next/next/arch/powerpc/platforms/powernv/opal-dump.c:100:2: error: implicit declaration of function 'sysfs_schedule_callback' [-Werror=implicit-function-declaration]
> > >   sysfs_schedule_callback(&dump_obj->kobj, delay_release_kobj,
> > >   ^
> > > cc1: all warnings being treated as errors
> > > 
> > > due to an interaction between d1ba277e7988908 (sysfs, driver-core: remove unused {sysfs|device}_schedule_callback_owner()) and 774fea1a38c6a5a8 (powerpc/powernv: Read OPAL error log and export it through sysfs) from the PowerPC tree.
> > > 
> > > I reverted 774fea1a38c6a5a8 for today.
> > 
> > Sounds like the powerpc tree also needs to stop using this function :)
> 
> So, explain to us in detail why the old interface could not be maintained
> for a release, please.  I thought we had become a bit more sophisticated
> about changing core APIs i.e. introduce the new API - fix up all the
> users - keep the old one around if possible for a release (or beyond
> -rc1) to catch the new users.
> 
> It may be that there is a good reason not to so this in this case, but it
> is not explained as far as I can see.

There were only 3 (or 4), users of this api, and no new ones had been
added in _years_, it's a very obscure thing, and odds are, it wouldn't
ever be added again, especially as it was just removed entirely not
being needed anymore.  And I'd argue, it's something that you shouldn't
have even been doing in the first place, so why a new user of it was
added now is quite strange to me.

thanks,

greg k-h
