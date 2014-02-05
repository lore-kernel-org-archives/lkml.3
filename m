Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbaBEXPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 18:15:47 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41032 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbaBEXPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 18:15:44 -0500
Date: Thu, 6 Feb 2014 00:15:40 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alex Thorlton <athorlton@sgi.com>
Cc: Russ Anderson <rja@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [BUG] Linux 3.14 fails to boot with new EFI changes
Message-ID: <20140205231540.GB6364@pd.tnic>
References: <20140128200754.GZ18196@sgi.com>
 <20140128225905.GN815@pd.tnic>
 <20140128234036.GB18196@sgi.com>
 <20140129141822.GC24887@pd.tnic>
 <20140130221950.GJ3105@sgi.com>
 <52EAD0F2.7090101@zytor.com>
 <20140131100722.GA21873@pd.tnic>
 <20140131140220.GC22498@sgi.com>
 <20140131142318.GC21873@pd.tnic>
 <20140205214536.GT3034@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140205214536.GT3034@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 03:45:36PM -0600, Alex Thorlton wrote:
> While working on an answer to this question, I ran across another issue
> on some newer hardware, that looks like it's definitely related to this
> problem, and might be the root cause.
> 
> When booting on a UV2 we die in efi_enter_virtual_mode:
> 
> BUG: unable to handle kernel paging request at 0000008f7e848020
> IP: [<000000007dadb6a9>] 0x7dadb6a8
> PGD 0

That looks very much like this other issue we're debugging right now:

http://marc.info/?l=linux-kernel&m=139115794830637

> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.11.0-medusa-00038-gd2f7cbe #821

...

> Let me know what other information you need and I'll get it to you ASAP.

You could try to boot latest linus + Matt's 'next' branch ontop and see
whether it is exploding. I'd venture a guess and say yes but a whole
dmesg with CONFIG_EFI_PGT_DUMP and pagetable dump might still give us
some clues.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
