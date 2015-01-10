Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbbAJNtO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 08:49:14 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:54250 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbbAJNtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 08:49:13 -0500
Message-ID: <54B12DD3.5020605@gmail.com>
Date: Sat, 10 Jan 2015 14:49:07 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>
CC: mtk.manpages@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, mpx: Ensure unused arguments of prctl() MPX requests
 are 0
References: <54AE5BE8.1050701@gmail.com> <87r3v350io.fsf@tassilo.jf.intel.com> <CAKgNAki3Fh8N=jyPHxxFpicjyJ=0kA75SJ65QjYzPmWnvy4nsw@mail.gmail.com> <54B01F41.10001@intel.com>
In-Reply-To: <54B01F41.10001@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2015 07:34 PM, Dave Hansen wrote:
> On 01/09/2015 10:25 AM, Michael Kerrisk (man-pages) wrote:
>> On 9 January 2015 at 18:25, Andi Kleen <andi@firstfloor.org> wrote:
>>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>>>> From: Michael Kerrisk <mtk.manpages@gmail.com>
>>>>
>>>> commit fe8c7f5cbf91124987106faa3bdf0c8b955c4cf7 added two new prctl()
>>>> operations, PR_MPX_ENABLE_MANAGEMENT and PR_MPX_DISABLE_MANAGEMENT.
>>>> However, no checks were included to ensure that unused arguments
>>>> are zero, as is done in many existing prctl()s and as should be
>>>> done for all new prctl()s. This patch adds the required checks.
>>>
>>> This will break the existing gcc run time, which doesn't zero these
>>> arguments.
>>
>> I'm a little lost here. Weren't these flags new in the
>> as-yet-unreleased 3.19? How does gcc run-time depends on them already?
> 
> These prctl()s have been around in some form or another for a few months
> since the patches had not yet been merged in to the kernel.  There is
> support for them in a set of (yet unmerged) gcc patches, as well as some
> tests which are only internal to Intel.
> 
> This change will, indeed, break those internal tests as well as the gcc
> patches.  As far as I know, the code is not in production anywhere and
> can be changed.  The prctl() numbers have changed while the patches were
> out of tree and it's a somewhat painful process each time it changes.
> It's not impossible, just painful.

So, sounds like thinks can be fixed (with mild inconvenience), and they
should be fixed before 3.19 is actually released.

Cheers,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
