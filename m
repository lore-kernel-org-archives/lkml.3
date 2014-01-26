Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbaAZEXH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 23:23:07 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57312 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbaAZEXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 23:23:05 -0500
Date: Sat, 25 Jan 2014 20:22:58 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Qiaowei Ren <qiaowei.ren@intel.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] x86, mpx: extend siginfo structure to include
 bound violation information
In-Reply-To: <1390727338-20487-5-git-send-email-qiaowei.ren@intel.com>
Message-ID: <alpine.DEB.2.02.1401252010400.10325@chino.kir.corp.google.com>
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com> <1390727338-20487-5-git-send-email-qiaowei.ren@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-1681630638-1390710182=:10325"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-1681630638-1390710182=:10325
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sun, 26 Jan 2014, Qiaowei Ren wrote:

> This patch adds new fields about bound violation into siginfo
> structure. si_lower and si_upper are respectively lower bound
> and upper bound when bound violation is caused.
> 
> These fields will be set in #BR exception handler by decoding
> the user instruction and constructing the faulting pointer.
> A userspace application can get violation address, lower bound
> and upper bound for bound violation from this new siginfo structure.
> 
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>

Same 32-bit warnings I reported for v2:

arch/x86/kernel/mpx.c: In function ‘do_mpx_bounds’:
arch/x86/kernel/mpx.c:407:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
arch/x86/kernel/mpx.c:409:3: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]

and the documentation says you explicitly want to support this config.

These types of warnings are usually indicative of real problems when 
you're storing upper and lower bits in 32-bit fields after casting them 
from 64-bit values.

I'm also not sure if the added fields to the generic struct siginfo can be 
justified for this.
--531381512-1681630638-1390710182=:10325--
