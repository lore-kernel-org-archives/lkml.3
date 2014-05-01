Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbaEAJEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 05:04:48 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43890 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848AbaEAJEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:04:46 -0400
Date: Thu, 1 May 2014 10:04:39 +0100
From: Will Deacon <will.deacon@arm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Victor Kamensky <victor.kamensky@linaro.org>
Subject: Re: [PATCH] word-at-a-time: avoid undefined behaviour in
 zero_bytemask macro
Message-ID: <20140501090438.GA30166@arm.com>
References: <1398271972-15177-1-git-send-email-will.deacon@arm.com>
 <5361698B.4060607@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5361698B.4060607@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Wed, Apr 30, 2014 at 10:22:19PM +0100, H. Peter Anvin wrote:
> On 04/23/2014 09:52 AM, Will Deacon wrote:
> > diff --git a/include/asm-generic/word-at-a-time.h b/include/asm-generic/word-at-a-time.h
> > index d3909effd725..d96deb443f18 100644
> > --- a/include/asm-generic/word-at-a-time.h
> > +++ b/include/asm-generic/word-at-a-time.h
> > @@ -50,11 +50,7 @@ static inline bool has_zero(unsigned long val, unsigned long *data, const struct
> >  }
> >  
> >  #ifndef zero_bytemask
> > -#ifdef CONFIG_64BIT
> > -#define zero_bytemask(mask)	(~0ul << fls64(mask))
> > -#else
> > -#define zero_bytemask(mask)	(~0ul << fls(mask))
> > -#endif /* CONFIG_64BIT */
> > -#endif /* zero_bytemask */
> > +#define zero_bytemask(mask) (~0ul << __fls(mask) << 1)
> > +#endif
> >  
> >  #endif /* _ASM_WORD_AT_A_TIME_H */
> > 
> 
> Why not:
> 
> #define zero_bytemask(mask) (~1ul << __fls(mask))

Yup, that'll work too -- it produces an identical disassembly for arm64.

Will
