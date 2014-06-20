Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbaFTQiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:38:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46868 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754882AbaFTQiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:38:16 -0400
Message-ID: <53A46365.6090101@zytor.com>
Date: Fri, 20 Jun 2014 09:37:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org
CC: bp@alien8.de, x86@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC][PATCH 3/3] x86: make MP  a required-feature on 64-bit
References: <20140620161736.D6AC16FD@viggo.jf.intel.com> <20140620161740.BFB00798@viggo.jf.intel.com> <53A46008.5060509@zytor.com> <53A4619C.8020100@sr71.net>
In-Reply-To: <53A4619C.8020100@sr71.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2014 09:30 AM, Dave Hansen wrote:
> On 06/20/2014 09:23 AM, H. Peter Anvin wrote:
>> On 06/20/2014 09:17 AM, Dave Hansen wrote:
>>>> Today, we assume that all 64-bit cpus have X86_FEATURE_MP.  It
>>>> should be in the REQUIRED_MASK so that we do not need the #undef
>>>> trick for it.
>> I don't think we enforce that the MP bit is set in CPUID, though.
>> Non-AMD processors will typically not set this bit at all, so the
>> feature validation code would have to be modified to know to not require
>> this bit.
> 
> Ahh, OK.  I'll drop this.
> 

We probably should just the cpu_has_mp macro entirely.  All it is used
for is printing a warning in amd_k7_smp_check().

Andi, Borislav -- as far as I can tell, we have *never* enforced this on
the 64-bit kernel, although we have enforced it on 64-bit processors
running the 32-bit kernel.  We should either enforce it on both or just
drop it.  What is your opinion?

	-hpa


