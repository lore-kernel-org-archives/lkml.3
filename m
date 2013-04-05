Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab3DELmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 07:42:52 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:45778 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab3DELmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 07:42:51 -0400
Message-ID: <515EB8B6.3070900@suse.cz>
Date: Fri, 05 Apr 2013 13:42:46 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: stable <stable@vger.kernel.org>
CC: hpa@linux.intel.com, Mel Gorman <mgorman@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [stable 3.0 revert request] x86-32, mm: Remove reference to resume_map_numa_kva()
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

in 3.0.67 there is this commit:
commit dbb694e810c87e7e1760527a783437f26ac5a547
Author: H. Peter Anvin <hpa@linux.intel.com>
Date:   Thu Jan 31 13:53:10 2013 -0800

    x86-32, mm: Remove reference to resume_map_numa_kva()

    commit bb112aec5ee41427e9b9726e3d57b896709598ed upstream.

    Remove reference to removed function resume_map_numa_kva().



But it depends on f03574f2 (which was applied to 3.2, 3.4, 3.7 and 3.8
stable trees, but not to 3.0). Now, when f03574f2 is not there, resume
from suspend dies terrible death on 32-bit:
Enabling non-boot CPUs ...
------------[ cut here ]------------
kernel BUG at mm/slab.c:532!
invalid opcode: 0000 [#1] SMP


In 3.0, we need either f03574f2:
commit f03574f2d5b2d6229dcdf2d322848065f72953c7
Author: Dave Hansen <dave@linux.vnet.ibm.com>
Date:   Wed Jan 30 16:56:16 2013 -0800

    x86-32, mm: Rip out x86_32 NUMA remapping code

or revert the commit above...

thanks,
-- 
js
suse labs
