Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760308Ab3IDLEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 07:04:24 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:51192 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab3IDLEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 07:04:23 -0400
X-Nat-Received: from [202.181.97.72]:60692 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1378292644.22327
To: ak@linux.intel.com, viro@ZenIV.linux.org.uk, geert@linux-m68k.org,
        akpm@linux-foundation.org
Cc: dhowells@redhat.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130903] module: broken module versions?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201308262306.DHB48401.OHFSVQJOtLFOMF@I-love.SAKURA.ne.jp>
	<201308271923.FCG13057.QLVHOFFSMtJOFO@I-love.SAKURA.ne.jp>
	<201309032031.BEH95862.VFSFMQLtOJFHOO@I-love.SAKURA.ne.jp>
In-Reply-To: <201309032031.BEH95862.VFSFMQLtOJFHOO@I-love.SAKURA.ne.jp>
Message-Id: <201309042004.BIG69713.QLOFOFOVSMtFHJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 4 Sep 2013 20:04:03 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 04092013 #10991169, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Tetsuo Handa wrote:
> I tried further debugging but not yet successful.

I found what was wrong.

Bad kernel config contained

  CONFIG_PHYSICAL_START=0x1000000
  CONFIG_PHYSICAL_ALIGN=0x100000

whereas good kernel config contained

  CONFIG_PHYSICAL_START=0x1000000
  CONFIG_PHYSICAL_ALIGN=0x1000000

. I think that there is no constraint checking for these values and resulted in
overlaying something on the kcrctab table.

Now linux-next-20130903 works fine. Thank you.
