Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbaKEXKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 18:10:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47182 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbaKEXKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 18:10:36 -0500
Date: Thu, 6 Nov 2014 00:10:32 +0100
From: Borislav Petkov <bp@alien8.de>
To: Steven Honeyman <stevenhoneyman@gmail.com>
Cc: Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jiri Kosina <trivial@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3b] x86, cpu: trivial printk formatting fixes
Message-ID: <20141105231032.GG5245@pd.tnic>
References: <1415227284.6634.26.camel@perches.com>
 <1415227938-16927-1-git-send-email-stevenhoneyman@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1415227938-16927-1-git-send-email-stevenhoneyman@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 10:52:18PM +0000, Steven Honeyman wrote:
> dmesg (from util-linux) currently has two methods for reading the kernel message ring buffer: /dev/kmsg and syslog(2). Since kernel 3.5.0 kmsg has been the default, which escapes control characters (e.g. new lines) before they are shown.
> 
> This change means that when dmesg is using /dev/kmsg, a 2 line printk makes the output messy, because the second line does not get a timestamp.
> For example:
> 
> [    0.012863] CPU0: Thermal monitoring enabled (TM1)
> [    0.012869] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
> Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
> [    0.012958] Freeing SMP alternatives memory: 28K (ffffffff81d86000 - ffffffff81d8d000)
> [    0.014961] dmar: Host address width 39
> 
> Because printk.c intentionally escapes control characters, they should not be there in the first place.
> This patch fixes two occurrences of this.
> 
> V2: Revert change to log level, only fix the newline formatting issue
> V3: Expand patch description
> V3b: Fix silly mistake (log level) 
> 
> Signed-off-by: Steven Honeyman <stevenhoneyman@gmail.com>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
