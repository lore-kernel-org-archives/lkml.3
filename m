Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaKLNiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:38:52 -0500
Received: from mga14.intel.com ([192.55.52.115]:43371 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbaKLNis convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:38:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="415391634"
From: "Anvin, H Peter" <h.peter.anvin@intel.com>
To: Borislav Petkov <bp@alien8.de>,
        Ross Zwisler <ross.zwisler@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: RE: [PATCH 3/6] x86: Add support for the clwb instruction
Thread-Topic: [PATCH 3/6] x86: Add support for the clwb instruction
Thread-Index: AQHP/d90ErPA0vQakUG7oLRaEWzcKpxddayA//+KiqE=
Date: Wed, 12 Nov 2014 13:38:45 +0000
Message-ID: <C40DC70F50313144AB3AF8625D4F407F71D61056@ORSMSX101.amr.corp.intel.com>
References: <1415731396-19364-1-git-send-email-ross.zwisler@linux.intel.com>
 <1415731396-19364-4-git-send-email-ross.zwisler@linux.intel.com>,<20141112123909.GD16807@pd.tnic>
In-Reply-To: <20141112123909.GD16807@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.4.15.193]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No, it doesn't.  x86 requires 3.4+ at a minimum.

________________________________
From: Borislav Petkov
Sent: Wednesday, November 12, 2014 4:39:09 AM
To: Ross Zwisler
Cc: linux-kernel@vger.kernel.org; Anvin, H Peter; Ingo Molnar; Thomas Gleixner; David Airlie; dri-devel@lists.freedesktop.org; x86@kernel.org
Subject: Re: [PATCH 3/6] x86: Add support for the clwb instruction

On Tue, Nov 11, 2014 at 11:43:13AM -0700, Ross Zwisler wrote:
> +static inline void clwb(volatile void *__p)
> +{
> +     alternative_io_2(".byte " __stringify(NOP_DS_PREFIX) "; clflush %P0",
> +                      ".byte 0x66; clflush %P0",
> +                      X86_FEATURE_CLFLUSHOPT,
> +                      ".byte 0x66; xsaveopt %P0",

Btw, I'm afraid you're going to have to spell out those new instruction
mnemonics as they aren't supported by older compilers:

  CC      drivers/gpu/drm/drm_cache.o
{standard input}: Assembler messages:
{standard input}:63: Error: no such instruction: `xsaveopt (%rax)'
{standard input}:249: Error: no such instruction: `xsaveopt (%rdi)'
{standard input}:283: Error: no such instruction: `xsaveopt -1(%rdx)'
make[1]: *** [drivers/gpu/drm/drm_cache.o] Error 1
make: *** [drivers/gpu/drm/drm_cache.o] Error 2
[boris@etch:14:35:40:k:14)->  gcc --version
gcc (GCC) 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)

This is on a very old guest I have which has this gcc in it and the
kernel supports everything gcc >= 3.2.

--
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
