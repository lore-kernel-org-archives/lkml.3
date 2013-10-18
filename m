Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab3JRPgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:36:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56054 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998Ab3JRPgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:36:53 -0400
Date: Fri, 18 Oct 2013 17:36:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: Joonas Saarinen <jza@saunalahti.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: AMD Bobcat cpufreq
Message-ID: <20131018153650.GE1007@pd.tnic>
References: <26801338.9419821382109781265.JavaMail.jza@saunalahti.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <26801338.9419821382109781265.JavaMail.jza@saunalahti.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 06:23:01PM +0300, Joonas Saarinen wrote:
> Borislav Petkov [bp@alien8.de] wrote:
> >You can also try turbostat in tools/power/x86/turbostat/
> >
> ># ./turbostat -i 1
> 
> We might be on to something. With work pinned on one core:
> 
> cor CPU   GHz  TSC
>        1.16 1.00
>  0   0 1.17 1.00
>  1   1 0.80 1.00
> 
> When both cores are occupied:
> 
> cor CPU   GHz  TSC
>        1.00 1.00
>  0   0 1.00 1.00
>  1   1 1.00 1.00
> 
> In this case both cores are limited to 1GHz, but it might be intentional
> to avoid overheating.

That's the boosting algorithm - the more parts of the silicon consume
power, the more it gets spread out amongst them so that each one of them
gets a smaller amount of the remaining power up to the TDP which is
available for consumption.

Also, AFAICT, on those machines the boosting algorithm involves the GPU
so that it boosts too. This might be the reason why you don't see 1.33
GHz with one of the cores.

> So there is some turbo functionality indeed. The frequency shown by
> turbostat is still a bit off the target, not sure if there is any
> actual problem though.

Yeah, see above.

I think all is fine with your box :)

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
