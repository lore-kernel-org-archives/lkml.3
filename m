Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbaJCU1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 16:27:25 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:61467 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaJCU1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 16:27:22 -0400
From: Giedrius Statkevicius <giedrius.statkevicius@gmail.com>
To: gregkh@linuxfoundation.org
Cc: micky_ching@realsil.com.cn, fabio.falzoi84@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] staging: rts5208: clean up coding style in rtsx_chip.c
Date: Fri,  3 Oct 2014 23:27:03 +0300
Message-Id: <1412368028-18935-1-git-send-email-giedrius.statkevicius@gmail.com>
X-Mailer: git-send-email 2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Giedrius Statkevičius <giedrius.statkevicius@gmail.com>

Align divided lines to the first line's opening paranthesis
Where two or more if's are in form 'if (a) if (b) { [...] }' convert them into one to lower the indentation level.
Use the ternary operator in places where there is code in format of: 'if (a) { b = foo1; } else { b = foo2; }'
Make the names of labels all lower case to avoid Camel Case.
Remove unnecessary parantheses around variables that are after a dereference operator like this: '&(a) => &a'
Switch the if condition around in 'if (0 == (value & (1 << bit))) {' to make it have the same form as the rest of the code.

After this patch checkpatch.pl without --strict doesn't complain about rtsx_chip.c at all and with --strict it only complains about the unmatched parantheses. I am reluctant to move that code with unmatched parantheses into another function to lower the indentation level because I don't have the hardware needed to test this driver and don't have enough experience to do it properly. Doing so would just probably hide the other problems this code has. My patch is purely about changing the code style without creating more functions and moving code to them. 

This patch is against Greg KH's staging-next tree.

Giedrius Statkevičius (5):
  Combine ifs into one where possible to avoid unnecessary indentation
    level increase
  Convert Camel Case labels to lower case, remove unnecessary
    parantheses after a dereference operator and remove empty lines
    before }
  Align lines of divided lines to the opening paranthesis where
    possible
  Divide lines to make them less than 80 characters long, align to the
    opening paranthesis where possible
  Use ternary operators where possible and sensible to avoid unnecessary
    increase of indentation level

 drivers/staging/rts5208/rtsx_chip.c | 322 +++++++++++++++---------------------
 1 file changed, 136 insertions(+), 186 deletions(-)

-- 
2.1.2

