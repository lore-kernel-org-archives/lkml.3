Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab3JHQXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:23:19 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:61618 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab3JHQXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:23:17 -0400
Message-ID: <5254315C.70401@linaro.org>
Date: Tue, 08 Oct 2013 09:22:52 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Zhan Jianyu <nasa4836@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Minchan Kim <minchan@kernel.org>,
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
Subject: Re: [PATCH 07/14] vrange: Purge volatile pages when memory is tight
References: <1380761503-14509-1-git-send-email-john.stultz@linaro.org> <1380761503-14509-8-git-send-email-john.stultz@linaro.org> <CAHz2CGWS+jWQU=v=5AnAgab1DrPr+snWvc62mf43Tx0aQUA8nA@mail.gmail.com>
In-Reply-To: <CAHz2CGWS+jWQU=v=5AnAgab1DrPr+snWvc62mf43Tx0aQUA8nA@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 08:27 PM, Zhan Jianyu wrote:
> On Thu, Oct 3, 2013 at 8:51 AM, John Stultz <john.stultz@linaro.org> wrote:
>>  static inline int page_referenced(struct page *page, int is_locked,
>>                                   struct mem_cgroup *memcg,
>> -                                 unsigned long *vm_flags)
>> +                                 unsigned long *vm_flags,
>> +                                 int *is_vrange)
>>  {
>>         *vm_flags = 0;
>> +       *is_vrange = 0;
>>         return 0;
>>  }
> I don't know if it is appropriate to add a parameter in such a  core
> function for an optional functionality. Maybe the is_vrange flag
> should be squashed into the vm_flags ? I am not sure .
Yea, this wasn't either Minchan or I were particularly fond of, but with
the vm_flags exausted, there wasn't a clear way to do so without doing
the rmap traversal again.

Other suggestions?  Extending the vm_flags to 64bits is something many
better mm devs have tried to merge unsuccessfully, so I'm hesitant to
try pushing it myself.

thanks
-john


