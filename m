Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934145AbaFSSD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 14:03:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60730 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933226AbaFSSD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 14:03:27 -0400
Message-ID: <53A325CE.5020206@zytor.com>
Date: Thu, 19 Jun 2014 11:02:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>, Borislav Petkov <bp@alien8.de>,
        Qiaowei Ren <qiaowei.ren@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 03/10] x86, mpx: add macro cpu_has_mpx
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com> <1403084656-27284-4-git-send-email-qiaowei.ren@intel.com> <20140618095739.GA24419@pd.tnic> <53A1A3A5.9010109@intel.com> <53A1A942.1090001@zytor.com> <53A1BD95.10701@intel.com>
In-Reply-To: <53A1BD95.10701@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 09:25 AM, Dave Hansen wrote:
> On 06/18/2014 07:59 AM, H. Peter Anvin wrote:
>> On 06/18/2014 07:35 AM, Dave Hansen wrote:
>>> It looks like static_cpu_has() is the right thing to use instead of
>>> boot_cpu_has().  But, this doesn't just obfuscate things.
>>>
>>> We actually _want_ the compiler to cull code out when the config option
>>> is off.  Things like do_bounds() will see code savings with _some_ kind
>>> of #ifdef rather than using static_cpu_has().
>>>
>>> So, we can either use the well worn, consistent with other features in
>>> x86, cpu_has_$foo approach.  Or, we can roll our own macros.
>>
>> We could do something like:
>>
>> #define MPX_ENABLED (IS_ENABLED(CONFIG_X86_MPX) &&
>> static_cpu_has(X86_FEATURE_MPX))
> 
> How about something like the attached patch?
> 
> This lets us use static_cpu_has() for the checks, and allows us to
> easily add new checks for other features that might be compile-time
> disabled.
> 

Hmm... I would like something similar to required-features.h which
reflect features which *cannot* be enabled or will always be ignored; we
actually already have a handful of those.

	-hpa

