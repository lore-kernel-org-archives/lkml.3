Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaKGUFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 15:05:40 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:54287 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbaKGUFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 15:05:39 -0500
Date: Fri, 7 Nov 2014 12:05:28 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Rodrigo Freire <rfreire@redhat.com>, Felix Fietkau <nbd@openwrt.org>,
        =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        Herton Krzesinski <hkrzesin@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org
Subject: Re: [RESEND PATCH V2] mtd: block2mtd: Present block2mtd timely on
 boot time
Message-ID: <20141107200528.GA24946@ld-irv-0074>
References: <2124950018.4236135.1414848795831.JavaMail.zimbra@redhat.com>
 <1415353480.958.301.camel@sauron.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415353480.958.301.camel@sauron.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 11:44:40AM +0200, Artem Bityutskiy wrote:
> On Sat, 2014-11-01 at 09:33 -0400, Rodrigo Freire wrote:
> > From: Felix Fietkau <nbd@openwrt.org> 
> > 
> > mtd: block2mtd: Ensure that block2mtd is presented timely on boot time
> > 
> > Currently, a block MTD device is not presented to the system on time, in 
> > order to start mounting the filesystems. This patch ensures that block2mtd 
> > is presented at the right time, so filesystems can be mounted on boot time. 
> > This issue is seen on BCM2835 (Raspberry Pi) systems when mounting JFFS2 
> > over block2mtd devices as the root filesystem.
> > This patchset also adds a MTD device name and a timeout option to the driver. 
> > Original patchset: 
> > https://dev.openwrt.org/browser/trunk/target/linux/generic/patches-3.12/440-block2mtd_init.patch?rev=40444 
> > https://dev.openwrt.org/browser/trunk/target/linux/generic/patches-3.12/441-block2mtd_probe.patch?rev=40444 
> 
> I  think you can mount jffs2 using /dev/mtdX, you do not need the block
> driver.

I realize you acknowledged your misunderstanding here, but for
posterity -- this point is addressed in the FAQ:

http://www.linux-mtd.infradead.org/faq/jffs2.html#L_mtdblock

Last I checked, the statement about busybox is still true. I think the
rootfs comment may be stale; I think the rootfstype= parameter can help
you.

Brian
