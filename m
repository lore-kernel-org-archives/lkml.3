Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab3IWLcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 07:32:06 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:45478 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab3IWLcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 07:32:04 -0400
MIME-Version: 1.0
Date: Mon, 23 Sep 2013 19:32:04 +0800
Message-ID: <CABVvea3mENMUqUtb2OGUN+vXqMVPVEgtna4w56gT1dh7gh7r7Q@mail.gmail.com>
Subject: [BUG] Buffer Overflow in drivers/video/fbmem.c
From: =?GB2312?B?0OzTwL2h?= <xuyongjiande@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Buffer overflow found in drivers/video/fbmem.c.
[Version]:Newest

[Detail]:
1592 static int do_register_framebuffer(struct fb_info *fb_info)
1593 {
1594 |   int i;
1595 |   struct fb_event event;
1596 |   struct fb_videomode mode;
........
1607 |   num_registered_fb++;
1608 |   for (i = 0 ; i < FB_MAX; i++)    //******* i could be FB_MAX
after loop *********/
1609 |   |   if (!registered_fb[i])
1610 |   |   |   break;
........

1646 |   fb_var_to_videomode(&mode, &fb_info->var);
1647 |   fb_add_videomode(&mode, &fb_info->modelist);
1648 |   registered_fb[i] = fb_info;          // ****** Here will be a
off-by-one overflow  *******/
