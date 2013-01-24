Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab3AXVP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:15:57 -0500
Received: from mail.kernel.org ([198.145.19.201]:40243 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756951Ab3AXVOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:14:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Benoit Goby <benoit@android.com>,
        Michal Nazarewicz <mina86@mina86.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 29/46] usb: gadget: FunctionFS: Fix missing braces in parse_opts
Date: Thu, 24 Jan 2013 13:13:07 -0800
Message-Id: <20130124211146.915074493@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211135.862755794@linuxfoundation.org>
References: <20130124211135.862755794@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benoit Goby <benoit@android.com>

commit b810075002c9f25a6da83cecda39d789000a04a9 upstream.

Add missing braces around an if block in ffs_fs_parse_opts. This broke
parsing the uid/gid mount options and causes mount to fail when using
uid/gid. This has been introduced by commit b9b73f7c (userns: Convert usb
functionfs to use kuid/kgid where appropriate) in 3.7.

Signed-off-by: Benoit Goby <benoit@android.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/f_fs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -1153,15 +1153,15 @@ static int ffs_fs_parse_opts(struct ffs_
 					pr_err("%s: unmapped value: %lu\n", opts, value);
 					return -EINVAL;
 				}
-			}
-			else if (!memcmp(opts, "gid", 3))
+			} else if (!memcmp(opts, "gid", 3)) {
 				data->perms.gid = make_kgid(current_user_ns(), value);
 				if (!gid_valid(data->perms.gid)) {
 					pr_err("%s: unmapped value: %lu\n", opts, value);
 					return -EINVAL;
 				}
-			else
+			} else {
 				goto invalid;
+			}
 			break;
 
 		default:


