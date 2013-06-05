Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801Ab3FEVe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:34:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab3FEVe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:34:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Binderman <dcb314@hotmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: [ 001/127] avr32: fix relocation check for signed 18-bit offset
Date: Wed,  5 Jun 2013 14:32:48 -0700
Message-Id: <20130605213218.169013266@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans-Christian Egtvedt <egtvedt@samfundet.no>

commit e68c636d88db3fda74e664ecb1a213ae0d50a7d8 upstream.

Caught by static code analysis by David.

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/avr32/kernel/module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/avr32/kernel/module.c
+++ b/arch/avr32/kernel/module.c
@@ -264,7 +264,7 @@ int apply_relocate_add(Elf32_Shdr *sechd
 			break;
 		case R_AVR32_GOT18SW:
 			if ((relocation & 0xfffe0003) != 0
-			    && (relocation & 0xfffc0003) != 0xffff0000)
+			    && (relocation & 0xfffc0000) != 0xfffc0000)
 				return reloc_overflow(module, "R_AVR32_GOT18SW",
 						     relocation);
 			relocation >>= 2;


