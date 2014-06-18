Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbaFRO74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:59:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46843 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbaFRO7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:59:53 -0400
Message-ID: <53A1A942.1090001@zytor.com>
Date: Wed, 18 Jun 2014 07:59:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>, Borislav Petkov <bp@alien8.de>,
        Qiaowei Ren <qiaowei.ren@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 03/10] x86, mpx: add macro cpu_has_mpx
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com> <1403084656-27284-4-git-send-email-qiaowei.ren@intel.com> <20140618095739.GA24419@pd.tnic> <53A1A3A5.9010109@intel.com>
In-Reply-To: <53A1A3A5.9010109@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 07:35 AM, Dave Hansen wrote:
> 
> It looks like static_cpu_has() is the right thing to use instead of
> boot_cpu_has().  But, this doesn't just obfuscate things.
> 
> We actually _want_ the compiler to cull code out when the config option
> is off.  Things like do_bounds() will see code savings with _some_ kind
> of #ifdef rather than using static_cpu_has().
> 
> So, we can either use the well worn, consistent with other features in
> x86, cpu_has_$foo approach.  Or, we can roll our own macros.
> 

We could do something like:

#define MPX_ENABLED (IS_ENABLED(CONFIG_X86_MPX) &&
static_cpu_has(X86_FEATURE_MPX))

	-hpa

