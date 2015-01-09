Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140AbbAISen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 13:34:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:29164 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbbAISel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 13:34:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,732,1413270000"; 
   d="scan'208";a="667270733"
Message-ID: <54B01F41.10001@intel.com>
Date: Fri, 09 Jan 2015 10:34:41 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: mtk.manpages@gmail.com, Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, mpx: Ensure unused arguments of prctl() MPX requests
 are 0
References: <54AE5BE8.1050701@gmail.com> <87r3v350io.fsf@tassilo.jf.intel.com> <CAKgNAki3Fh8N=jyPHxxFpicjyJ=0kA75SJ65QjYzPmWnvy4nsw@mail.gmail.com>
In-Reply-To: <CAKgNAki3Fh8N=jyPHxxFpicjyJ=0kA75SJ65QjYzPmWnvy4nsw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2015 10:25 AM, Michael Kerrisk (man-pages) wrote:
> On 9 January 2015 at 18:25, Andi Kleen <andi@firstfloor.org> wrote:
>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>>> From: Michael Kerrisk <mtk.manpages@gmail.com>
>>>
>>> commit fe8c7f5cbf91124987106faa3bdf0c8b955c4cf7 added two new prctl()
>>> operations, PR_MPX_ENABLE_MANAGEMENT and PR_MPX_DISABLE_MANAGEMENT.
>>> However, no checks were included to ensure that unused arguments
>>> are zero, as is done in many existing prctl()s and as should be
>>> done for all new prctl()s. This patch adds the required checks.
>>
>> This will break the existing gcc run time, which doesn't zero these
>> arguments.
> 
> I'm a little lost here. Weren't these flags new in the
> as-yet-unreleased 3.19? How does gcc run-time depends on them already?

These prctl()s have been around in some form or another for a few months
since the patches had not yet been merged in to the kernel.  There is
support for them in a set of (yet unmerged) gcc patches, as well as some
tests which are only internal to Intel.

This change will, indeed, break those internal tests as well as the gcc
patches.  As far as I know, the code is not in production anywhere and
can be changed.  The prctl() numbers have changed while the patches were
out of tree and it's a somewhat painful process each time it changes.
It's not impossible, just painful.
