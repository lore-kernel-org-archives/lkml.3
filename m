Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336AbaFTD30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 23:29:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38261 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775AbaFTD3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 23:29:25 -0400
Message-ID: <53A3AA70.5090401@zytor.com>
Date: Thu, 19 Jun 2014 20:28:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>, Borislav Petkov <bp@alien8.de>,
        Qiaowei Ren <qiaowei.ren@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 03/10] x86, mpx: add macro cpu_has_mpx
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com> <1403084656-27284-4-git-send-email-qiaowei.ren@intel.com> <20140618095739.GA24419@pd.tnic> <53A1A3A5.9010109@intel.com> <53A1A942.1090001@zytor.com> <53A1BD95.10701@intel.com> <53A325CE.5020206@zytor.com> <53A330DD.1090106@intel.com>
In-Reply-To: <53A330DD.1090106@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2014 11:50 AM, Dave Hansen wrote:
> On 06/19/2014 11:02 AM, H. Peter Anvin wrote:
>> On 06/18/2014 09:25 AM, Dave Hansen wrote:
>>> How about something like the attached patch?
>>>
>>> This lets us use static_cpu_has() for the checks, and allows us to
>>> easily add new checks for other features that might be compile-time
>>> disabled.
>>
>> Hmm... I would like something similar to required-features.h which
>> reflect features which *cannot* be enabled or will always be ignored; we
>> actually already have a handful of those
> 
> Could you elaborate a bit?  I'll try and include them in the approach to
> make sure it works broadly.
> 
> Is there a benefit to the required-features.h approach that's missing
> from mine?  I _believe_ all of the compiler optimization around
> __builtin_constant_p() continues to work with the inline function
> instead of the #defines and bitmasks.  I think the inline function
> approach is a bit easier to work with.
> 
> Could the required-features.h approach just be from a time before
> __builtin_constant_p() worked well across inlines?
> 

Not so much.  What I don't want is one approach for doing things in one
direction and another approach for the other direction.

	-hpa

