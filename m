Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab3ISO6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 10:58:40 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47423 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752531Ab3ISO6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 10:58:38 -0400
X-Sasl-enc: snrPFU2Dh77rhrog7Ez3krNvSkRktZDHu9XHMa8djdag 1379602717
Date: Thu, 19 Sep 2013 11:58:34 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Andreas Herrmann <herrmann.der.user@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: Issues with AMD microcode updates
Message-ID: <20130919145834.GA4298@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jacob, Andreas,

I take care of the amd64 microcode update support for Debian, and I'm
receiving user reports of lockup issues with the AMD microcode driver in
several kernels.  This is about the runtime update interface,
/sys/devices/system/cpu/*/microcode/reload and
/sys/devices/system/cpu/microcode/reload.

Basically, the issue is that the process that tries to write "1" to the
reload node gets stuck in "D" state on several kernel versions.

I started by blacklisting several older kernels (e.g. I got a report of
2.6.38 locking up), but recently I got a report of a lockup with kernel
3.5.1.  Blacklisting everything before 3.10 is not exactly kosher, not when
I would have to blindly trust 3.0, 3.2 and 3.4 to not have whatever issue is
causing the lockups.

IMHO that's the point where it becomes interesting to actually track down
the bug even if it apparently doesn't exist anymore on the more recent
kernels, and ensure that the stable/long-term kernels have the fix.  That
would also help distros blacklist microcode update on the broken kernels.

Unfortunately, I don't own, or have access to, any boxes with an AMD
processor (let alone one with an AMD processor in need of a microcode
update) to bissect the problem.

I'd appreciate if AMD (or anyone with an AMD processor, really) could help
me track this issue down.

Debian bug reports:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=717185
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=723081

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
