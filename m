Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162381Ab3DESP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 14:15:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38458 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162332Ab3DESP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 14:15:57 -0400
Message-ID: <515F14B6.9090603@zytor.com>
Date: Fri, 05 Apr 2013 11:15:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/3] x86: routines to choose random kernel base offset
References: <1365106055-22939-1-git-send-email-keescook@chromium.org> <1365106055-22939-2-git-send-email-keescook@chromium.org> <20130405072405.GD26889@gmail.com> <20130405073621.GA27843@gmail.com>
In-Reply-To: <20130405073621.GA27843@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2013 12:36 AM, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@kernel.org> wrote:
> 
>>
>> * Kees Cook <keescook@chromium.org> wrote:
>>
>>> This provides routines for selecting a randomized kernel base offset, 
>>> bounded by e820 details. It tries to use RDRAND and falls back to RDTSC. 
>>> If "noaslr" is on the kernel command line, no offset will be used.
>>
>> Would it make sense to also add three other sources of entropy:
> 
> In any case, would it be possible to also mix these bootup sources of 
> entropy into our regular random pool?
> 
> That would improve random pool entropy on all Linux systems, not just 
> those that choose to enable kernel-base-address randomization.
> 

I think we already do at least some of these, but at this point, for any
non-RDRAND-capable hardware we could almost certainly do better for any
definition of anything at all.

RDRAND is obviously the ultimate solution here.

	-hpa


