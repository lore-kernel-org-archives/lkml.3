Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab3AJWDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 17:03:43 -0500
Received: from talus.maths.usyd.edu.au ([129.78.68.1]:44791 "EHLO
	talus.maths.usyd.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab3AJWDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 17:03:42 -0500
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jan 2013 17:03:42 EST
X-smtpdoor-from: psz@maths.usyd.edu.au
X-smtpdoor-want-Message-ID: <201301102158.r0ALwI4i031014@como.maths.usyd.edu.au>
Date: Fri, 11 Jan 2013 08:58:18 +1100
From: paul.szabo@sydney.edu.au
Message-Id: <201301102158.r0ALwI4i031014@como.maths.usyd.edu.au>
To: linux-mm@kvack.org
Subject: [RFC] Reproducible OOM with partial workaround
Cc: 695182@bugs.debian.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Linux-MM,

On a machine with i386 kernel and over 32GB RAM, an OOM condition is
reliably obtained simply by writing a few files to some local disk
e.g. with:
  n=0; while [ $n -lt 99 ]; do dd bs=1M count=1024 if=/dev/zero of=x$n; ((n=$n+1)); done
Crash usually occurs after 16 or 32 files written. Seems that the
problem may be avoided by using mem=32G on the kernel boot, and that
it occurs with any amount of RAM over 32GB.

I developed a workaround patch for this particular OOM demo, dropping
filesystem caches when about to exhaust lowmem. However, subsequently
I observed OOM when running many processes (as yet I do not have an
easy-to-reproduce demo of this); so as I suspected, the essence of the
problem is not with FS caches.

Could you please help in finding the cause of this OOM bug?

Please see
http://bugs.debian.org/695182
for details, in particular my workaround patch
http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=101;att=1;bug=695182

(Please reply to me directly, as I am not a subscriber to the linux-mm
mailing list.)

Thanks, Paul

Paul Szabo   psz@maths.usyd.edu.au   http://www.maths.usyd.edu.au/u/psz/
School of Mathematics and Statistics   University of Sydney    Australia
