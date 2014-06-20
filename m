Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbaFTRU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 13:20:28 -0400
Received: from www.sr71.net ([198.145.64.142]:54204 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756875AbaFTRU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 13:20:27 -0400
Message-ID: <53A46D59.1000505@sr71.net>
Date: Fri, 20 Jun 2014 10:20:25 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
CC: bp@alien8.de, x86@kernel.org
Subject: Re: [RFC][PATCH 1/3] x86: introduce disabled-features
References: <20140620161736.D6AC16FD@viggo.jf.intel.com> <53A45F5D.90505@zytor.com>
In-Reply-To: <53A45F5D.90505@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2014 09:20 AM, H. Peter Anvin wrote:
>> > +#ifdef CONFIG_X86_INTEL_MPX
>> > +# define HAVE_MPX	(1<<(X86_FEATURE_MPX & 31))
>> > +#else
>> > +# define HAVE_MPX	0
>> > +#endif
>> > +
> Is this an inverted test?

Yes, that was inverted.  I've renamed it to make it a bit easier to read:

#ifdef CONFIG_X86_INTEL_MPX
# define DISABLE_MPX    0
#else
# define DISABLE_MPX    (1<<(X86_FEATURE_MPX & 31))
#endif

