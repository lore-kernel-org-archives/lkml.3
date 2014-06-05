Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbaFEEPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:15:35 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:33820 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbaFEEPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:15:32 -0400
From: Honggang Li <enjoymindful@gmail.com>
To: user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net
Cc: richard@nod.at, linux-kernel@vger.kernel.org,
        Honggang Li <enjoymindful@gmail.com>
Subject: [PATCH linux-next] remove csum_partial_copy_generic_i386 to clean up exception table
Date: Thu,  5 Jun 2014 12:15:23 +0800
Message-Id: <1401941724-6703-1-git-send-email-enjoymindful@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <538F275B.7000508@nod.at>
References: <538F275B.7000508@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The csum_partial_copy_generic_i386 never been called. It mess up x86 uml kernel
exception table. So remove it.

linux-next]$ grep -n -r  csum_partial_copy_generic_i386 .
./arch/x86/um/checksum_32.S:249:csum_partial_copy_generic_i386:
./arch/x86/um/checksum_32.S:384:csum_partial_copy_generic_i386:

Honggang Li (1):
  remove csum_partial_copy_generic_i386 to clean up exception table

 arch/x86/um/checksum_32.S | 239 ----------------------------------------------
 1 file changed, 239 deletions(-)

-- 
1.8.3.1

