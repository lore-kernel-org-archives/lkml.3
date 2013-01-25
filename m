Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab3AYBsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 20:48:13 -0500
Received: from talus.maths.usyd.edu.au ([129.78.68.1]:44988 "EHLO
	talus.maths.usyd.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab3AYBsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 20:48:05 -0500
X-smtpdoor-from: psz@maths.usyd.edu.au
X-smtpdoor-want-Message-ID: <201301250147.r0P1l00t001070@como.maths.usyd.edu.au>
Date: Fri, 25 Jan 2013 12:47:00 +1100
From: paul.szabo@sydney.edu.au
Message-Id: <201301250147.r0P1l00t001070@como.maths.usyd.edu.au>
To: fengguang.wu@intel.com
Subject: Re: [PATCH] Negative (setpoint-dirty) in bdi_position_ratio()
Cc: 695182@bugs.debian.org, akpm@linux-foundation.org, jack@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20130125005529.GA21668@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Fengguang,

> There are 260MB reclaimable slab pages in the normal zone ...

Marked "all_unreclaimable? yes": is that wrong? Question asked also in:
http://marc.info/?l=linux-mm&m=135873981326767&w=2

> ... however we somehow failed to reclaim them. ...

I made a patch that would do a drop_caches at that point, please see:
http://bugs.debian.org/695182
http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=101;filename=drop_caches.patch;att=1;bug=695182
http://marc.info/?l=linux-mm&m=135785511125549&w=2
and that successfully avoided OOM when writing files.
But, the drop_caches patch did not protect against the "sleep test".

> ... What's your filesystem and the content of /proc/slabinfo?

Filesystem is EXT3. See output of slabinfo in Debian bug above or in
http://marc.info/?l=linux-mm&m=135796154427544&w=2

Thanks, Paul

Paul Szabo   psz@maths.usyd.edu.au   http://www.maths.usyd.edu.au/u/psz/
School of Mathematics and Statistics   University of Sydney    Australia
