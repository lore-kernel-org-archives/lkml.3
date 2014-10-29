Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351AbaJ2Kfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:35:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37087 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932091AbaJ2Kff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:35:35 -0400
Message-ID: <5450C2F3.40400@suse.com>
Date: Wed, 29 Oct 2014 11:35:31 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
CC: hpa@zytor.com, x86@kernel.org, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, toshi.kani@hp.com
Subject: Re: [PATCH V4 1/3] x86: Make page cache mode a real type
References: <1414392513-24645-1-git-send-email-jgross@suse.com> <1414392513-24645-2-git-send-email-jgross@suse.com> <alpine.DEB.2.11.1410281536170.5308@nanos> <20141029102859.GA11260@gmail.com>
In-Reply-To: <20141029102859.GA11260@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2014 11:28 AM, Ingo Molnar wrote:
>
> * Thomas Gleixner <tglx@linutronix.de> wrote:
>
>> On Mon, 27 Oct 2014, Juergen Gross wrote:
>>> At the moment there are a lot of places that handle setting or getting
>>> the page cache mode by treating the pgprot bits equal to the cache mode.
>>> This is only true because there are a lot of assumptions about the setup
>>> of the PAT MSR. Otherwise the cache type needs to get translated into
>>> pgprot bits and vice versa.
>>>
>>> This patch tries to prepare for that by introducing a separate type
>>> for the cache mode and adding functions to translate between those and
>>> pgprot values.
>>>
>>> To avoid too much performance penalty the translation between cache mode
>>> and pgprot values is done via tables which contain the relevant
>>> information.  Write-back cache mode is hard-wired to be 0, all other
>>> modes are configurable via those tables. For large pages there are
>>> translation functions as the PAT bit is located at different positions
>>> in the ptes of 4k and large pages.
>>
>> I'm fine with the approach itself. Though I wish you had split this
>> patch in several sanely to review pieces.
>>
>>    - Introduce enums, helper functions etc. which basically reflect
>>      the state of today
>>
>>    - Change the usage sites to use the enums and helpers
>>
>>    - Convert the enum/helper implementation to the new scheme
>>
>>    - Split out the printk change
>>
>>    ...
>
> That absolutely has to be done, should any of this introduce
> regressions. The diffstat:
>
>   18 files changed, 344 insertions(+), 212 deletions(-)
>
> is _way_ too large.

Okay, will do.

Juergen

