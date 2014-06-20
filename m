Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934867AbaFTQX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:23:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46727 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631AbaFTQXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:23:55 -0400
Message-ID: <53A46008.5060509@zytor.com>
Date: Fri, 20 Jun 2014 09:23:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org
CC: bp@alien8.de, x86@kernel.org
Subject: Re: [RFC][PATCH 3/3] x86: make MP  a required-feature on 64-bit
References: <20140620161736.D6AC16FD@viggo.jf.intel.com> <20140620161740.BFB00798@viggo.jf.intel.com>
In-Reply-To: <20140620161740.BFB00798@viggo.jf.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2014 09:17 AM, Dave Hansen wrote:
> Today, we assume that all 64-bit cpus have X86_FEATURE_MP.  It
> should be in the REQUIRED_MASK so that we do not need the #undef
> trick for it.

I don't think we enforce that the MP bit is set in CPUID, though.
Non-AMD processors will typically not set this bit at all, so the
feature validation code would have to be modified to know to not require
this bit.

	-hpa

>  
> -#define REQUIRED_MASK1	(NEED_LM|NEED_3DNOW)
> +#define REQUIRED_MASK1	(NEED_LM|NEED_3DNOW|NEED_MP)
>  

