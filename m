Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab3CDJwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:52:25 -0500
Received: from mail-wi0-f193.google.com ([209.85.212.193]:45849 "EHLO
	mail-wi0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab3CDJwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:52:24 -0500
MIME-Version: 1.0
Date: Mon, 4 Mar 2013 17:52:22 +0800
Message-ID: <CAAO_Xo7sEH5W_9xoOjax8ynyjLCx7GBpse+EU0mF=9mEBFhrgw@mail.gmail.com>
Subject: Inactive memory keep growing and how to release it?
From: Lenky Gao <lenky.gao@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When i just run a test on Centos 6.2 as follows:

#!/bin/bash

while true
do

	file="/tmp/filetest"

	echo $file

	dd if=/dev/zero of=${file} bs=512 count=204800 &> /dev/null

	sleep 5
done

the inactive memory keep growing:

#cat /proc/meminfo | grep Inactive\(fi
Inactive(file):   420144 kB
...
#cat /proc/meminfo | grep Inactive\(fi
Inactive(file):   911912 kB
...
#cat /proc/meminfo | grep Inactive\(fi
Inactive(file):  1547484 kB
...

and i cannot reclaim it:

# cat /proc/meminfo | grep Inactive\(fi
Inactive(file):  1557684 kB
# echo 3 > /proc/sys/vm/drop_caches
# cat /proc/meminfo | grep Inactive\(fi
Inactive(file):  1520832 kB

I have tested on other version kernel, such as 2.6.30 and .6.11, the
problom also exists.

When in the final situation, i cannot kmalloc a larger contiguous
memory, especially in interrupt context.
Can you give some tips to avoid this?

PS:
# uname -a
Linux localhost.localdomain 2.6.32-220.el6.x86_64 #1 SMP Tue Dec 6
19:48:22 GMT 2011 x86_64 x86_64 x86_64 GNU/Linux



--
Regards,

Lenky
