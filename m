Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab3JHAHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 20:07:35 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35242 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab3JHAHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 20:07:34 -0400
Message-ID: <52534CC1.1090009@linaro.org>
Date: Mon, 07 Oct 2013 17:07:29 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Dhaval Giani <dhaval.giani@gmail.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>, Rob Clark <robdclark@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 05/14] vrange: Add new vrange(2) system call
References: <1380761503-14509-1-git-send-email-john.stultz@linaro.org> <1380761503-14509-6-git-send-email-john.stultz@linaro.org> <52533C12.9090007@zytor.com> <5253404D.2030503@linaro.org> <20131008000357.GC25780@bbox>
In-Reply-To: <20131008000357.GC25780@bbox>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 05:03 PM, Minchan Kim wrote:
> Hello, John and Peter
>
> On Mon, Oct 07, 2013 at 04:14:21PM -0700, John Stultz wrote:
>> On 10/07/2013 03:56 PM, H. Peter Anvin wrote:
>>> I see from the change history of the patch that this was an madvise() at
>>> some point, but was changed into a separate system call at some point,
>>> does anyone remember why that was?  A quick look through my LKML
>>> archives doesn't really make it clear.
>> The reason we can't use madvise, is that to properly handle error cases
>> and report the pruge state, we need an extra argument.
>>
>> In much earlier versions, we just returned an error when setting
>> NONVOLATILE if the data was purged. However, since we have to possibly
>> do allocations when marking a range as non-volatile, we needed a way to
>> properly handle that allocation failing. We can't just return ENOMEM, as
>> we may have already marked purged memory as non-volatile.
>>
>> Thus, that's why with vrange, we return the number of bytes modified,
>> along with the purge state. That way, if an error does occur we can
>> return the purge state of the bytes successfully modified, and only
>> return an error if nothing was changed, much like when a write fails.
> As well, we might need addtional argument VRANGE_FULL/VRANGE_PARTIAL
> for vrange system call. I discussed it long time ago but omitted it
> for early easy review phase. It is requested by Mozilla fork and of course
> I think it makes sense to me.
>
> https://lkml.org/lkml/2013/3/22/20
>
> In short, if you mark a range with VRANGE_FULL, kernel can discard all
> of pages within the range if memory is tight while kernel can discard
> part of pages in the vrange if you mark the range with VRANGE_PARTIAL.

Yea, I'm still not particularly fond of userland being able to specify
the purging semantics, but as we discussed earlier, this can be debated
in finer detail as an extension to the merged interface. :)

thanks
-john

