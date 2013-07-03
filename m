Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab3GCP1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 11:27:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53629 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab3GCP1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 11:27:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Stehle Vincent-B46079" <B46079@freescale.com>
Subject: Re: [PATCH v10] i2c-designware: make SDA hold time configurable
Date: Wed, 3 Jul 2013 17:26:41 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Christian Ruppert <christian.ruppert@abilis.com>,
        Wolfram Sang <wsa@the-dreams.de>, Rob Herring <robherring2@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
References: <20130625163902.GA2973@katana> <20130703145918.GE3929@ab42.lan> <F7C43F8B2814514CA05F3436BC68046EF379F0@039-SN2MPN1-011.039d.mgd.msft.net>
In-Reply-To: <F7C43F8B2814514CA05F3436BC68046EF379F0@039-SN2MPN1-011.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307031726.42167.arnd@arndb.de>
X-Provags-ID: V02:K0:unOVJI25o2ueMeOVo0sh3qKtfvQXPXj38tOtnRvr1vU
 +IDvbsR9XrDR5bLzOEg88YzxRh8DlyVMz6DPYSXKM4MCBQkiiV
 Z9dfvk6GMClYX629R0B+d/g2GUV+xEx27EnhxTAOzRk4Dvzo9G
 aCz80rvj/+KWCIkGUO5PGVELnGhGmeaPhGhsV3P8iEXYzTR8oh
 guX4IsuM1/j3Tkz1BswiVcJTdjSsccDCUgACvLPJRSTEwCvHtQ
 q9w6ESAE431abr7PAKkR7DidjYxv22vX5/YSNHSNy3GuEcuDoH
 cTDVlYcf08zx/67ukszxlG3J+EPRvvBBAEQ9mwJriqBplGAG2s
 okpcG+HXu+GaEfq3gH9A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 July 2013, Stehle Vincent-B46079 wrote:
> > From: Christian Ruppert [mailto:christian.ruppert@abilis.com]
> (..)
> > Although this doesn't explicitly state what the function returns to me
> > this sounds more like the quotient is returned rather than the remainder?
> 
> Hi,
> 
> Yes div_u64() returns the quotient.
> 
> It is defined in linux/math64.h as:
> 
>   static inline u64 div_u64(u64 dividend, u32 divisor)
>   {
>           u32 remainder;
>           return div_u64_rem(dividend, divisor, &remainder);
>   }
> 
> The remainder is probably fully optimized out.

Ah, you are right, sorry for the confusion on my part.

I thought you had used do_div() rather than div_u64().
Everything's fine then, feel free to add my

Acked-by: Arnd Bergmann <arnd@arndb.de>

to your patch.

	Arnd
