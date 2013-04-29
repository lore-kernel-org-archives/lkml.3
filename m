Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab3D2PjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 11:39:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41750 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757260Ab3D2PjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 11:39:07 -0400
Message-ID: <517E9405.8030509@zytor.com>
Date: Mon, 29 Apr 2013 08:38:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 2/3] x86: Sanity-check static_cpu_has usage
References: <1367244262-29511-1-git-send-email-bp@alien8.de> <1367244262-29511-3-git-send-email-bp@alien8.de>
In-Reply-To: <1367244262-29511-3-git-send-email-bp@alien8.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2013 07:04 AM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> static_cpu_has may be used only after alternatives have run. Before that
> it always returns false if constant folding with __builtin_constant_p()
> doesn't happen. And you don't want that.
> 
> This patch is the result of me debugging an issue where I overzealously
> put static_cpu_has in code which executed before alternatives have run
> and had to spend some time with scratching head and cursing at the
> monitor.
> 
> So add a jump to a warning which screams loudly when we use this
> function too early. The alternatives patch that check away in
> conjunction with patching the rest of the kernel image.
> 
> This first JMP the compiler then issues should always be a two-byte JMP
> because its relative offset fits in a byte. This gets replaced by only a
> two-byte NOP => less instruction cache bloat.
> 

I still would prefer this to be an option.

	-hpa


