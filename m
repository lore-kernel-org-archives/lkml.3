Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab3DSVZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 17:25:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59180 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413Ab3DSVZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 17:25:23 -0400
Date: Fri, 19 Apr 2013 23:25:14 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        fenghua.yu@intel.com
Subject: Re: [PATCH] x86: Add check for P5 to microcode_intel_early
Message-ID: <20130419212514.GC3075@pd.tnic>
References: <1366392183-4149-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie>
 <20130419191128.GA21991@pd.tnic>
 <5171AA86.604@nexus-software.ie>
 <20130419205515.GA3075@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130419205515.GA3075@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 10:55:15PM +0200, Borislav Petkov wrote:
> Just filter out P5 and earlier. The code already does that for CPUs
> which don't have CPUID.

Actually, an alternative - more practical albeit not very accurate
solution would be to check for which families Intel delivers microcode
and do the cut off there with a comment as to why you do it like that.

I very much doubt, Intel will add microcode for *older* families to the
package :-).

IOW, in the linux intel-microcode package we currently have:

$ tree /lib/firmware/intel-ucode/
├── 06-0f-02
├── 06-0f-06
├── 06-0f-07
├── 06-0f-0a
├── 06-0f-0b
├── 06-0f-0d
├── 06-16-01
├── 06-17-06
├── 06-17-07
├── 06-17-0a
├── 06-1a-04
├── 06-1c-02
├── 06-1c-0a
├── 06-1d-01
├── 06-1e-04
├── 06-1e-05
├── 06-25-02
├── 06-25-05
├── 06-2a-07
├── 06-2d-06
├── 06-2d-07
├── 06-2f-02
├── 06-3a-09
├── 0f-04-01
├── 0f-04-03
├── 0f-04-04
├── 0f-04-07
├── 0f-04-08
├── 0f-04-09
├── 0f-04-0a
├── 0f-06-02
├── 0f-06-04
├── 0f-06-05
└── 0f-06-08

So < 6 should be fine.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
