Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab3JNK0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 06:26:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53272 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874Ab3JNK0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 06:26:46 -0400
Date: Mon, 14 Oct 2013 12:26:35 +0200
From: Borislav Petkov <bp@alien8.de>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 3/8] ACPI, x86: Extended error log driver for x86 platform
Message-ID: <20131014102635.GC4009@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-4-git-send-email-gong.chen@linux.intel.com>
 <20131011152451.GF5925@pd.tnic>
 <20131014031633.GA12189@gchen.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131014031633.GA12189@gchen.bj.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 13, 2013 at 11:16:33PM -0400, Chen Gong wrote:
> But this driver can be loaded as a module. If this module is unloaded,
> extlog_print is gone. I can't keep such a pointer internally.

Sure you can - you define a weak extlog_print() function in a
compilation unit which is always builtin. Maybe mce.c or so.

> This macro is great and I'd loved to use it. But it looks like a
> litttle bit weird to let eMCA depends on a header file like edac.h.
> Meanwhile, I found in drivers/video/sis/init.c:3323 we have a very
> similar macro for this purpose. So how about writing a separate patch
> to clean it up first?

Actually, you're right. Those macros are much more generic and
could be exposed to the general public by putting them, say into
include/include/bitops.h, for example?

Btw, the sis one generates unsigneds (4 byte on x86) while the edac one
8 byte ULLs. So you could call them

GENMASK
and
GENMASK_ULL

How does that sound?

> Because I think in theory "CPU < 0" is impossible. When it hits such
> situation, it should be a very serious H/W or firmware bug. At least,
> It think it should be a WARN_ON.

Yes, I think a WARN_ON is much better than the heavy hammer. We can
always turn it into a FW_BUG later if it really starts to trigger
anywhere...

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
