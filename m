Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab3HALgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 07:36:31 -0400
Received: from rrzmta1.uni-regensburg.de ([194.94.155.51]:42984 "EHLO
	rrzmta1.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab3HALga convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:2:1>);
	Thu, 1 Aug 2013 07:36:30 -0400
Message-Id: <51FA6455020000A100012182@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 01 Aug 2013 13:36:21 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Cc: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
Subject: Possible mmap() write() problem in SLES11 SP2 kernel
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks!

I think I'd let you know (maybe I'm wrong, and the kernel is right):

I write a C-program that maps a file into an private writable map. Then I modify the area a bit and use one write to write that area back to a file.

This worked fine in SLES11 kernel 3.0.74-0.6.10. However with kernel  3.0.80-0.7 the write() fails with EFAULT if the output file is the same as the input file.

The strace is amazingly short (I removed the unrelated calls):
open("xxx", O_RDONLY)                   = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=4416, ...}) = 0
mmap(NULL, 4416, PROT_READ|PROT_WRITE, MAP_PRIVATE, 3, 0) = 0x7f85ac045000
close(3)                                = 0
open("xxx", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 3
write(3, 0x7f85ac045000, 4414)          = -1 EFAULT (Bad address)
close(3)                                = 0
munmap(0x7f85ac045000, 4414)            = 0

I want to have your attention if this should work, and you get my attention if this should not work. Note that the input file is closed before it's opened for write again. As the output file is typically shorter than the input, I didn't want to use a non-private mapping and a truncate, just in case you wonder...

Regards,
Ulrich


