Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaE0ACG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 20:02:06 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:55699 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaE0ACC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 20:02:02 -0400
Message-ID: <5383D5F5.2000303@gmail.com>
Date: Tue, 27 May 2014 08:01:57 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] arch: unicore32: ksyms: export several implemeted symbols
 to avoid compiling failure
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unicore32 has implemented 'find_first_bit', 'find_first_zero_bit',
'pm_power_off', and '__cpuc_coherent_kern_range', need export them to
avoid compiling failure.

The related error (with allmodconfig under unicore32):

    MODPOST 4039 modules
  ERROR: "find_first_bit" [sound/soc/codecs/snd-soc-uda1380.ko] undefined!
  ERROR: "find_first_zero_bit" [net/sctp/sctp.ko] undefined!
  [...]
  ERROR: "__cpuc_coherent_kern_range" [drivers/misc/lkdtm.ko] undefined!
  ERROR: "pm_power_off" [drivers/mfd/retu-mfd.ko] undefined!
  [...]

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/unicore32/kernel/ksyms.c   | 2 ++
 arch/unicore32/kernel/process.c | 1 +
 arch/unicore32/mm/proc-syms.c   | 2 ++
 3 files changed, 5 insertions(+)


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
