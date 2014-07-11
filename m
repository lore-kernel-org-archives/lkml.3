Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbaGKCaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 22:30:25 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:5549 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751999AbaGKCaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 22:30:24 -0400
Date: Thu, 10 Jul 2014 22:30:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: No uart output on my snowball board
Message-ID: <20140710223021.6e9c857f@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I decided to play with my snowball board as that's the easiest arm
board I have to do testing on, and it was reported to me that I broke
function graph tracing on the arm boards. But I haven't booted my
snowball since 3.8. When I tried with the latest kernel, it didn't give
me *any* output. I figured something was up with the uart, but the
board also didn't boot.

I did a bisect to find out where the uart stopped working (I also
stumbled on where the board stopped booting, but still need to find
that commit). The uart died with this commit:

commit a0998b8321eb5f53ef51924f5ab6c69237ac1025
Author: Lee Jones <lee.jones@linaro.org>
Date:   Thu Aug 22 16:18:56 2013 +0100

    ARM: ux500: Remove UART support when booting without Device Tree
    
    It's time to remove all ATAG support from ux500 and rely solely on
    Device Tree booting. This patch is part of that endeavour.
    
    Signed-off-by: Lee Jones <lee.jones@linaro.org>
    Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

This happened between 3.12 and 3.13.

Does this mean that I need to get device tree support for this. I have
no idea how to fix it as a device tree to me is a christmas tree (a
tree with little lighty devices on it). Thus I'll just go and throw
this out at you.

Thanks,

-- Steve
