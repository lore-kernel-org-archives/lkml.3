Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab3FXKRC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:17:02 -0400
Received: from intranet.asianux.com ([58.214.24.6]:43150 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab3FXKRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:17:00 -0400
X-Spam-Score: -100.6
Message-ID: <51C81C68.5080101@asianux.com>
Date: Mon, 24 Jun 2013 18:16:08 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
        Tony Lindgren <tony@atomide.com>, "olof@lixom.net" <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v2] arch: arm64: kernel: add '#ifdef CONFIG_COMPAT' for
 aarch32_break_handler()
References: <51C53C06.7050205@asianux.com> <51C81115.4070803@asianux.com> <20130624101429.GF23779@mudshark.cambridge.arm.com>
In-Reply-To: <20130624101429.GF23779@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 06:14 PM, Will Deacon wrote:
> On Mon, Jun 24, 2013 at 10:27:49AM +0100, Chen Gang wrote:
>> > 
>> > If 'COMPAT' not defined, aarch32_break_handler() cannot pass compiling,
>> > and it can work independent with 'COMPAT', so remove dummy definition.
>> > 
>> > The related make:
>> > 
>> >   make ARCH=arm64 randconfig
>> >   make ARCH=arm64 menuconfig
>> >   make ARCH=arm64 V=1 EXTRA_CFLAGS=-W
> This sequence isn't really very useful, so I wouldn't bother including it in
> the commit message. You can trigger this issue just by disabling
> CONFIG_COMPAT.
> 

OK, thanks. Next time, I need notice about it.

>> > The related error:
>> > 
>> >   arch/arm64/kernel/debug-monitors.c:249:5: error: redefinition of ‘aarch32_break_handler’
>> >   In file included from arch/arm64/kernel/debug-monitors.c:29:0:
>> >   /root/linux-next/arch/arm64/include/asm/debug-monitors.h:89:12: note: previous definition of ‘aarch32_break_handler’ was here
>> > 
>> > 
>> > 
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> > ---
>> >  arch/arm64/include/asm/debug-monitors.h |    7 -------
>> >  1 files changed, 0 insertions(+), 7 deletions(-)
>> > 
>> > diff --git a/arch/arm64/include/asm/debug-monitors.h b/arch/arm64/include/asm/debug-monitors.h
>> > index ef8235c..a2232d0 100644
>> > --- a/arch/arm64/include/asm/debug-monitors.h
>> > +++ b/arch/arm64/include/asm/debug-monitors.h
>> > @@ -83,14 +83,7 @@ static inline int reinstall_suspended_bps(struct pt_regs *regs)
>> >  }
>> >  #endif
>> >  
>> > -#ifdef CONFIG_COMPAT
>> >  int aarch32_break_handler(struct pt_regs *regs);
>> > -#else
>> > -static int aarch32_break_handler(struct pt_regs *regs)
>> > -{
>> > -	return -EFAULT;
>> > -}
>> > -#endif
> Code looks fine to me:
> 
>   Acked-by: Will Deacon <will.deacon@arm.com>

Thanks.

-- 
Chen Gang

Asianux Corporation
