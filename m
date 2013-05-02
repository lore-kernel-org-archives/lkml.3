Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017Ab3EBMvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 08:51:49 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:46127 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867Ab3EBMvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 08:51:47 -0400
Message-ID: <51826176.2070104@suse.cz>
Date: Thu, 02 May 2013 14:52:06 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
CC: lwn@lwn.net
Subject: [stable 3.0] s390 build breakage [was: Linux 3.0.75]
References: <20130426043017.GA22553@kroah.com>
In-Reply-To: <20130426043017.GA22553@kroah.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2013 06:30 AM, Greg KH wrote:
> Linus Torvalds (5): vm: add vm_iomap_memory() helper function

Hi, this one breaks s390 on 3.0:
mm/memory.c: In function 'vm_iomap_memory':
mm/memory.c:2363: error: implicit declaration of function
'io_remap_pfn_range'

It looks like 4f2e29031e6c67802e7370292dd050fd62f337ee is needed:
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Apr 17 08:46:19 2013 -0700

    s390: move dummy io_remap_pfn_range() to asm/pgtable.h


But it depends on the s390 PCI support...

Whatever, it should be OK to take only the second hunk from that
patch, it seems.

thanks,
-- 
js
suse labs
