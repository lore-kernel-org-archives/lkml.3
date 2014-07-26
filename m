Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbaGZTNO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:13:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34143 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbaGZTNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ted Juan <ted.juan@gmail.com>, Pekon Gupta <pekon@ti.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH 3.14 77/87] mtd: devices: elm: fix elm_context_save() and elm_context_restore() functions
Date: Sat, 26 Jul 2014 12:02:51 -0700
Message-Id: <20140726190217.108592207@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190214.530473925@linuxfoundation.org>
References: <20140726190214.530473925@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ted Juan <ted.juan@gmail.com>

commit 6938ad40cb97a52d88a763008935340729a4acc7 upstream.

These two function's switch case lack the 'break' that make them always
return error.

Signed-off-by: Ted Juan <ted.juan@gmail.com>
Acked-by: Pekon Gupta <pekon@ti.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/devices/elm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mtd/devices/elm.c
+++ b/drivers/mtd/devices/elm.c
@@ -428,6 +428,7 @@ static int elm_context_save(struct elm_i
 					ELM_SYNDROME_FRAGMENT_1 + offset);
 			regs->elm_syndrome_fragment_0[i] = elm_read_reg(info,
 					ELM_SYNDROME_FRAGMENT_0 + offset);
+			break;
 		default:
 			return -EINVAL;
 		}
@@ -466,6 +467,7 @@ static int elm_context_restore(struct el
 					regs->elm_syndrome_fragment_1[i]);
 			elm_write_reg(info, ELM_SYNDROME_FRAGMENT_0 + offset,
 					regs->elm_syndrome_fragment_0[i]);
+			break;
 		default:
 			return -EINVAL;
 		}


