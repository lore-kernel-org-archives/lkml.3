Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298Ab3CFPAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 10:00:23 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:63443 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab3CFPAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 10:00:21 -0500
X-Nat-Received: from [202.181.97.72]:52913 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1362581889.25863
To: bp@alien8.de, dave@linux.vnet.ibm.com
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [3.9-rc1 x86] Bug in ioremap code?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201303060041.AIF15342.tJFOHLQFFOMVSO@I-love.SAKURA.ne.jp>
	<20130305180650.GD4914@pd.tnic>
	<201303060628.CBG00578.OJtMFFHLQVSFOO@I-love.SAKURA.ne.jp>
	<51367104.5050200@linux.vnet.ibm.com>
	<20130305224432.GD27022@pd.tnic>
In-Reply-To: <20130305224432.GD27022@pd.tnic>
Message-Id: <201303062358.EFG90616.HLtSQFJFOMVOFO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 6 Mar 2013 23:58:08 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 06032013 #9672708, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> Ok, before we continue guessing stuff, Tetsuo, can you please explain
> how exactly you're triggering this. More specifically, we need .config,
> hypervisor version, I'm assuming kernel is 3.9-rc1, Linux is guest/host
> etc, etc.

I'm using CentOS 6.3 x86_32 guest running on VMware Workstation 6.5.5 for
Windows XP x86_32 host and VMware Player 4.0.5 for Windows 7 x86_64 host.

Kernel version is 3.9-rc1 x86_32. This bug can be triggered only when the
guest has little RAM such that /proc/meminfo reports that HighTotal == 0.
Config is at http://I-love.SAKURA.ne.jp/tmp/config-3.9-rc1-acpi .

I don't know why but changing kernel config to CONFIG_ACPI=n
( http://I-love.SAKURA.ne.jp/tmp/config-3.9-rc1-noacpi ) solves this bug.
Well, should I run bisection on ACPI code?

Regards.
