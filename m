Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934359AbaFSSuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 14:50:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:14728 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933059AbaFSSuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 14:50:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,508,1400050800"; 
   d="scan'208";a="560321060"
Message-ID: <53A330DD.1090106@intel.com>
Date: Thu, 19 Jun 2014 11:50:05 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Qiaowei Ren <qiaowei.ren@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 03/10] x86, mpx: add macro cpu_has_mpx
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com> <1403084656-27284-4-git-send-email-qiaowei.ren@intel.com> <20140618095739.GA24419@pd.tnic> <53A1A3A5.9010109@intel.com> <53A1A942.1090001@zytor.com> <53A1BD95.10701@intel.com> <53A325CE.5020206@zytor.com>
In-Reply-To: <53A325CE.5020206@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2014 11:02 AM, H. Peter Anvin wrote:
> On 06/18/2014 09:25 AM, Dave Hansen wrote:
>> How about something like the attached patch?
>>
>> This lets us use static_cpu_has() for the checks, and allows us to
>> easily add new checks for other features that might be compile-time
>> disabled.
> 
> Hmm... I would like something similar to required-features.h which
> reflect features which *cannot* be enabled or will always be ignored; we
> actually already have a handful of those

Could you elaborate a bit?  I'll try and include them in the approach to
make sure it works broadly.

Is there a benefit to the required-features.h approach that's missing
from mine?  I _believe_ all of the compiler optimization around
__builtin_constant_p() continues to work with the inline function
instead of the #defines and bitmasks.  I think the inline function
approach is a bit easier to work with.

Could the required-features.h approach just be from a time before
__builtin_constant_p() worked well across inlines?
