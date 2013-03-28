Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab3C1UAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 16:00:42 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:46120 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab3C1UAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 16:00:41 -0400
Date: Thu, 28 Mar 2013 12:54:56 -0700
From: Olof Johansson <olof@lixom.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        kernel list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 3.9-rc1 regression in arm dtb build
Message-ID: <20130328195456.GA22527@quad.lixom.net>
References: <20130306193332.GA6022@amd.pavel.ucw.cz>
 <5137C404.9060902@wwwdotorg.org>
 <20130307144506.GB7344@amd.pavel.ucw.cz>
 <5138FDAE.8060202@wwwdotorg.org>
 <20130311050546.GA21863@quad.lixom.net>
 <CACxGe6vkC7fjzf1-+K8O81+w=jQ63PvuTEhSPyitEBA9XiKYnw@mail.gmail.com>
 <20130328092916.GA11187@amd.pavel.ucw.cz>
 <51545870.4010209@wwwdotorg.org>
 <20130328193323.GA25166@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130328193323.GA25166@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 08:33:23PM +0100, Pavel Machek wrote:
> On Thu 2013-03-28 08:49:20, Stephen Warren wrote:
> > On 03/28/2013 03:29 AM, Pavel Machek wrote:
> > ...
> > > There's change that makes it pretty much impossible to build dtbs
> > > reliably between different kernel versions, because it leaves old dtbs
> > > around, and they survive even make clean.
> > 
> > One question here: Presumably the dtbs don't survive "make clean" if you
> > run that right after building the dtbs, but only if you check out a new
> > kernel version before running clean? Or is that not the case?
> 
> That was the case I seen, yes.
> 
> Have old kernel running, dtbs building. Apply a patch. It starts
> behaving weird. You do make clean... but you still get old dtbs.
> 
> (It would be nice if make socfpga_cyclone5.dtb would magically remove
> all the dtbs from old location; make dtbs does that if I understand
> stuff correctly).


This takes care of the "make dtbs" case (or just "make" case), but not
when you build a specific target.




ARM: dts: remove stale dtb files from arch/arm/boot

This will result in stale dtb files being removed from arch/arm/boot, which
can cause confusion when someone goes from an older kernel version to a newer
one without doing make clean on the old version (or git clean -f -d -x).


Signed-off-by: Olof Johansson <olof@lixom.net>

index 84aa2ca..b1127b8 100644
--- a/arch/arm/boot/Makefile
+++ b/arch/arm/boot/Makefile
@@ -115,4 +115,5 @@ i:
 	$(CONFIG_SHELL) $(srctree)/$(src)/install.sh $(KERNELRELEASE) \
 	$(obj)/Image System.map "$(INSTALL_PATH)"
 
+clean-files := *.dtb
 subdir-	    := bootp compressed dts
