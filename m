Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbaB0OTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 09:19:04 -0500
Received: from collab.rosalab.ru ([195.19.76.181]:49088 "EHLO
	collab.rosalab.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaB0OTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:19:02 -0500
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Feb 2014 09:19:01 EST
Message-ID: <530F4776.2050507@rosalab.ru>
Date: Thu, 27 Feb 2014 18:11:02 +0400
From: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
Organization: ROSA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] KernelStrider 0.3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KernelStrider 0.3 has been released.

KernelStrider system can be used to detect data races in the Linux 
kernel modules, especially the drivers involved in wired and wireless 
networking. Currently, it works on x86 only. The code is under GPL v2 
license.

KernelStrider instruments the kernel modules under analysis in runtime. 
When the code of these modules is executed, KernelStrider collects 
information about the memory locations accessed by that code, about the 
functions called, etc. The collected data are passed to user space where 
they can be analyzed by ThreadSanitizer (Google) [1] to reveal potential 
races.

Most significant changes in version 0.3:
* Implemented compression of the output data with LZO to increase 
throughput, etc.
* Provided a helper script (kedr.py) to simplify loading/unloading of 
kernel-mode components.
* Applied several fixes in handling of NAPI callbacks and netdev operations.
* Fixed handling of recursive calls (such things can still be found in 
some out-of-tree kernel modules).
* Fixed lockdep warnings in the handlers for alloc/free operations.

Downloads, tutorials, etc., are available at
http://code.google.com/p/kernel-strider/

Now that version 0.3 is out, I might finally find time to experiment 
with compile-time instrumentation suggested by some of you many times 
(in addition to the runtime instrumentation technique used in 
KernelStrider now). In some future version, I also plan to make 
KernelStrider part of KEDR framework [2], which I also maintain.

Suggestions, bug reports and other kinds of feedback are welcome, as usual.

Regards,
Eugene

[1] http://code.google.com/p/data-race-test/
[2] http://code.google.com/p/kedr/

-- 
Eugene Shatokhin, ROSA
www.rosalab.com
