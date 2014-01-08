Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbaAHThF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 14:37:05 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39426 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbaAHThA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 14:37:00 -0500
Date: Wed, 8 Jan 2014 20:36:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: halfdog <me@halfdog.net>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Sanitize CPU-state when switching tasks (was sanitize CPU-state
 when switching from virtual-8086 mode to other task)
Message-ID: <20140108193655.GD5098@pd.tnic>
References: <52BF4A80.3010503@halfdog.net>
 <52BF8AEE.6020904@zytor.com>
 <52C089AC.4000401@halfdog.net>
 <52C0C9F4.50101@zytor.com>
 <52C196C3.1040300@halfdog.net>
 <52C31027.2030101@zytor.com>
 <20131231192106.GA22535@phenom.dumpdata.com>
 <52C347F0.8070902@zytor.com>
 <52CD022E.9040107@halfdog.net>
 <52CD8E10.3010204@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52CD8E10.3010204@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 09:42:40AM -0800, H. Peter Anvin wrote:
> Adding Borislav.
> 
> Boris, do you happen to know of any erratum on AMD E-350 which may be
> in play here?

Interesting. Well, nothing looks even remotely related from looking at the F14h
rev guide here:

http://developer.amd.com/wordpress/media/2012/10/47534_14h_Mod_00h-0Fh_Rev_Guide.pdf

Btw, hd (if that is your real name :-)), can you post /proc/cpuinfo? I
think I might have a E-350 here too and I could try to reproduce. Btw,
how exactly do you trigger?

You run FpuStateTaskSwitchShmemXattrHandlersOverwriteWithNullPage.c
first to modify shmem_xattr_handlers and then
ManipulatedXattrHandlerForPrivEscalation.c? You need a 32-bit kernel and
userspace, right? Anything else?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
