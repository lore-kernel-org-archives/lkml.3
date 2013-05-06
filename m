Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab3EFPo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:44:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57455 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755188Ab3EFPo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:44:26 -0400
Date: Mon, 6 May 2013 17:49:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: Wengmeiling <wengmeiling.weng@huawei.com>
Cc: Libo Chen <libo.chen@huawei.com>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: bcdedcc1afd6 breaks search in menuconfig
Message-ID: <20130506154903.GD22041@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I do

make menuconfig

then press '/' in order to search for a symbol, and I type 'EFI', for
example, and press enter, I get:

 │  Enter CONFIG_ (sub)string to search for (with or without "CONFIG_")    │  
 │ ┌─────────────────────────────────────────────────────────────────────┐ │  
 │ │EFImake[1]: *** [menuconfig] Segmentation fault                      │ │  
 │ └───────────────────────────────────────────────make: *** [menuconfig] Error 2

and the terminal is left in an inconsistent state which I need to
'reset'. But, more importantly, the search is b0rked now.

Reverting the above commit fixes the issue.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
