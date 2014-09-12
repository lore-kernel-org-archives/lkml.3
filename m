Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaILRsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:48:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:49219 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaILRsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:48:40 -0400
Date: Fri, 12 Sep 2014 19:48:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Dave Hansen <dave.hansen@intel.com>, Qiaowei Ren <qiaowei.ren@intel.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 07/10] x86, mpx: decode MPX instruction to get bound
 violation information
In-Reply-To: <5412F7AB.5040901@zytor.com>
Message-ID: <alpine.DEB.2.10.1409121943430.4178@nanos>
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com> <1410425210-24789-8-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.10.1409120015030.4178@nanos> <5412230A.6090805@intel.com> <541223B1.5040705@zytor.com> <alpine.DEB.2.10.1409120133330.4178@nanos>
 <54127A16.4030701@zytor.com> <alpine.DEB.2.10.1409121238290.4178@nanos> <5412F7AB.5040901@zytor.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014, H. Peter Anvin wrote:
> The correct limit is 15 bytes, not anything else, so this is a bug in
> the existing decoder.  A sequence of bytes longer than 15 bytes will

Fine. Lets fix it there.

> #UD, regardless of being "otherwise valid".

> Keep in mind the instruction may not be aligned, and you could fit an
> instruction plus a jump and still overrun a page in 15 bytes.

Fair enough. OTOH, I doubt that a text mapping will end exactly at
that jump after the MPX instruction.

So that's simple to fix.

Kill the hardcoded limit in lib/insn.c and let the callsites hand in a
lenght argument. So you can still use it for MPX and avoid 200 lines
of blindly copied and slightly different decoder code.

Thanks,

	tglx
