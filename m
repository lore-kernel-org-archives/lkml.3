Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab3CFTdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 14:33:36 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50207 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab3CFTdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 14:33:35 -0500
Date: Wed, 6 Mar 2013 20:33:32 +0100
From: Pavel Machek <pavel@denx.de>
To: kernel list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux@arm.linux.org.uk,
        arnd@arndb.de, olof@lixom.net, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        torvalds@linux-foundation.org
Subject: 3.9-rc1 regression in arm dtb build
Message-ID: <20130306193332.GA6022@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Commit

commit 499cd8298628eeabf0eb5eb6525d4faa0eec80d8
Author: Grant Likely <grant.likely@secretlab.ca>
Date:   Tue Nov 27 16:29:11 2012 -0700

    The current rules have the .dtb files build in a different
    directory
    from the .dts files. The only reason for this is that it was what
    PowerPC has done historically. This patch changes ARM to use the
generic dtb rule which builds .dtb files in the same directory as the
source .dts.

--

Moves dtb files from arch/arm/boot/ to arch/arm/boot/dtb. That causes
several problems:

1) it is inconsistent with 3.8, making switching between 3.9-rc1 and
3.8 tricky

2) what is worse, it is very easy to do stuff like

   make socfpga_cyclone5.dtb

   and you end up with success, but stale file in arch/arm/boot, where
   your scripts expect it.

   (There are some attempts to rm stale files in Makefiles; they don't
   work in above case).

3) it is now incosistent between powerpc and arm.

4) device tree _binary_ files are now output in device tree _source_
directory

(Sorry for noticing this earlier).

I believe the commit should be simply reverted. Reasons to move dtbs
around are not good enough.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
