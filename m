Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab3DUJvy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 05:51:54 -0400
Received: from lvps176-28-13-145.dedicated.hosteurope.de ([176.28.13.145]:58922
	"EHLO lvps176-28-13-145.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752946Ab3DUJvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 05:51:53 -0400
X-Greylist: delayed 518 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Apr 2013 05:51:53 EDT
From: Tim Sander <tim@krieglstein.org>
Organization: Sander & Lightning
To: linux-arm-kernel@lists.infradead.org
Subject: Pinmuxing with devicetree (beaglebone)
Date: Sun, 21 Apr 2013 11:43:50 +0200
User-Agent: KMail/1.13.7 (Linux/3.8.0-rc6-00008-g8b31849; KDE/4.8.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201304211143.50961.tim@krieglstein.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I am currently trying to get pinmuxing working on a beaglebone board with an 
offtree driver. This is for a custom handbuild hardware so i guess there is no 
point in bringing this mainline.

While this is havyly patched 3.8.4 version running over here i think the
pinmux infrastructure is the new standard way. At least there is a 
pinctrl/44e10800.pinmux directory in debugfs?

My last aproach was using the devicetree but beeing new to this devicetree 
stuff i just got stuck: 
http://comments.gmane.org/gmane.linux.ports.arm.kernel/231204

Now i tried use the way it is described in Documentation/pinctrl.txt but still 
there are the includes missing: #include <linux/pinctrl/consumer.h>.

Also while there is a /sys/kernel/debug/pinctrl/44e10800.pinmux in debugfs i 
found that not so intuitive as the omap_mux which disappeared. Also i didn't 
find any documentation for this debugfs stuff.

So what is the recommended way to get this stupid pinmuxing going. In pre 
devicetree days one would just pick the mux.h include of the platform and 
initialized the muxers which was pretty straight forward. Now with device tree 
its much more complicated. No proper syntax checking as with the c definitions 
and no documentation how to get this magic stuff working :-(.

The whole stuff is build by a ptxdist (a embedded buildsystem) and can be 
found over here:
https://gitorious.org/ptxdist-beaglebone/ptxdist-beaglebone

Best regards
Tim
