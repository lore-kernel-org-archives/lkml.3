Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933393Ab3GPRBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:01:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44461 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932889Ab3GPRBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:01:21 -0400
Date: Tue, 16 Jul 2013 19:00:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Cc: Jacob Shin <jacob.shin@amd.com>, linux-kernel@vger.kernel.org,
        Jacob Shin <jacob.w.shin@gmail.com>
Subject: Re: early microcode on amd is broken when no initramfs provided
Message-ID: <20130716170055.GG4402@pd.tnic>
References: <20130709183601.5d567a83@fem.tu-ilmenau.de>
 <20130710073049.GA15525@pd.tnic>
 <20130711230525.40bc6491@fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130711230525.40bc6491@fem.tu-ilmenau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 11:05:25PM +0200, Johannes Hirte wrote:
> config is attached

Ok, I can reproduce the hang with your config but even with:

$ grep MICROCODE .config
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set

which means, it cannot be microcode-related.

And I'd bet if you wait a minute (yep, it should be exactly 60 seconds)
the boot would probably continue. And if so, this is that 60 sec delay
where the kernel tries to find firmware.

Hmm...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
