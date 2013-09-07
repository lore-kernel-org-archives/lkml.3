Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401Ab3IGLpx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 07:45:53 -0400
Received: from blu0-omc1-s31.blu0.hotmail.com ([65.55.116.42]:59060 "EHLO
	blu0-omc1-s31.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209Ab3IGLpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 07:45:52 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Sep 2013 07:45:52 EDT
X-TMN: [2NEEh7XgvZ09HH5T3NWUFWRuCeuK9kN9]
X-Originating-Email: [meskilla@outlook.com]
Message-ID: <BLU0-SMTP1270709DA425DAB477295E0C43D0@phx.gbl>
Content-Type: text/plain; charset="utf-8"; format=flowed; delsp=yes
Subject: Problems with splice
Date: Sat, 7 Sep 2013 13:39:47 +0200
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: Mayk Eskila <meskilla@outlook.com>
User-Agent: Opera Mail/12.16 (Linux)
X-OriginalArrivalTime: 07 Sep 2013 11:39:41.0941 (UTC) FILETIME=[F1379250:01CEABBE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

I intend to upgrade my own disc and partition cloning program by using  
splice. When running splice-cp.c from current git on my average dualcore  
hardware with kernel 3.10 I found that copying 1G files with splice is  
about twice as fast as using plain vanilla cp.

However I have encountered the following problems:

a) When trying to copy files with 2G size the program immediately  
terminates with the error "open input: Value too large for defined data  
type".

b) When trying to copy from a harddisc partition like /dev/sdb1 the  
program immediately terminates without any error and without copying.

c) When output is directed to /dev/null transfer speeds are extremely bad.

I guess that a+b might be due to size being larger than 32bit value. Is  
this a bug in the kernel or how can it be prevented from a user space  
program?

c) I guess that the code run when outputting to /dev/null takes it's time,  
but I intend to use that possibility for benchmarking pure read  
throughputs. In the current program I detect that special case and do not  
open the output file and in the copying loop skip all writing code. How  
could this be done by using the splice
family and thus avoid copying data to user space?

d) I also intend to use it for wiping discs and partitions. I know how to  
fill a buffer with zeros or pseudo random data, but how can I avoid  
repeatedly copying that data into kernel space?

Many thanks for your help!

Mayk
