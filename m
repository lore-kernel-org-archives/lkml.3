Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031145AbaGDW5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:57:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbaGDWRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:17:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.15 42/66] powernv: Fix permissions on sysparam sysfs entries
Date: Fri,  4 Jul 2014 15:14:41 -0700
Message-Id: <20140704221424.729981391@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221422.813435485@linuxfoundation.org>
References: <20140704221422.813435485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 1bd098903fda069cb96fe8b5cb4595b46c683385 upstream.

Everyone can write to these files, which is not what we want.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/powernv/opal-sysparam.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/platforms/powernv/opal-sysparam.c
+++ b/arch/powerpc/platforms/powernv/opal-sysparam.c
@@ -260,10 +260,10 @@ void __init opal_sys_param_init(void)
 			attr[i].kobj_attr.attr.mode = S_IRUGO;
 			break;
 		case OPAL_SYSPARAM_WRITE:
-			attr[i].kobj_attr.attr.mode = S_IWUGO;
+			attr[i].kobj_attr.attr.mode = S_IWUSR;
 			break;
 		case OPAL_SYSPARAM_RW:
-			attr[i].kobj_attr.attr.mode = S_IRUGO | S_IWUGO;
+			attr[i].kobj_attr.attr.mode = S_IRUGO | S_IWUSR;
 			break;
 		default:
 			break;


