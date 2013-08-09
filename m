Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030806Ab3HITUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 15:20:37 -0400
Received: from 1wt.eu ([62.212.114.60]:35241 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030485Ab3HITUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 15:20:36 -0400
Date: Fri, 9 Aug 2013 21:20:30 +0200
From: Willy Tarreau <w@1wt.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 000/102] 3.10.6-stable review
Message-ID: <20130809192030.GD4079@1wt.eu>
References: <20130809015010.208118575@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thu, Aug 08, 2013 at 06:56:36PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.6 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Just checked on my OpenBlocks AX3 (dual-core ARMv7 in thumbs mode),
everything seems OK, I did not even notice any performance regression
compared to 3.10.5 on syscall intensive workloads with the recent
changes. I'm sure that I'm using the kuser helpers page since the
system doesn't boot without. Also I did observe minor changes in
/proc/self/maps, but I don't think they should have any impact, so
all in all it's OK :

3.10.6-rc1:
root@ax3:~# cat /proc/self/maps 
00008000-00014000 r-xp 00000000 01:00 258        /bin/cat
0001c000-0001d000 rw-p 0000c000 01:00 258        /bin/cat
0001d000-0003e000 rw-p 00000000 00:00 0          [vectors]
b6ea6000-b6fc8000 r-xp 00000000 01:00 638        /lib/libc-2.17.so
b6fc8000-b6fcf000 ---p 00122000 01:00 638        /lib/libc-2.17.so
b6fcf000-b6fd1000 r--p 00121000 01:00 638        /lib/libc-2.17.so
b6fd1000-b6fd2000 rw-p 00123000 01:00 638        /lib/libc-2.17.so
b6fd2000-b6fd5000 rw-p 00000000 00:00 0          [vectors]
b6fd5000-b6ff4000 r-xp 00000000 01:00 744        /lib/ld-2.17.so
b6ff8000-b6ffa000 rw-p 00000000 00:00 0          [vectors]
b6ffa000-b6ffb000 r-xp 00000000 00:00 0          [vectors]
b6ffb000-b6ffc000 r--p 0001e000 01:00 744        /lib/ld-2.17.so
b6ffc000-b6ffd000 rw-p 0001f000 01:00 744        /lib/ld-2.17.so
be99d000-be9be000 rw-p 00000000 00:00 0          [vectors]
ffff0000-ffff1000 r-xp 00000000 00:00 0          [vectors]

3.10.5:
root@ax3:~# cat /proc/self/maps 
00008000-00014000 r-xp 00000000 01:00 258        /bin/cat
0001c000-0001d000 rw-p 0000c000 01:00 258        /bin/cat
0001d000-0003e000 rw-p 00000000 00:00 0          [heap]
b6e6f000-b6f91000 r-xp 00000000 01:00 638        /lib/libc-2.17.so
b6f91000-b6f98000 ---p 00122000 01:00 638        /lib/libc-2.17.so
b6f98000-b6f9a000 r--p 00121000 01:00 638        /lib/libc-2.17.so
b6f9a000-b6f9b000 rw-p 00123000 01:00 638        /lib/libc-2.17.so
b6f9b000-b6f9e000 rw-p 00000000 00:00 0 
b6f9e000-b6fbd000 r-xp 00000000 01:00 744        /lib/ld-2.17.so
b6fc2000-b6fc4000 rw-p 00000000 00:00 0 
b6fc4000-b6fc5000 r--p 0001e000 01:00 744        /lib/ld-2.17.so
b6fc5000-b6fc6000 rw-p 0001f000 01:00 744        /lib/ld-2.17.so
be9e0000-bea01000 rw-p 00000000 00:00 0          [stack]
ffff0000-ffff1000 r-xp 00000000 00:00 0          [vectors]

Best regards,
Willy

