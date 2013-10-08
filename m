Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab3JHD2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 23:28:40 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:37993 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab3JHD2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 23:28:38 -0400
MIME-Version: 1.0
In-Reply-To: <1380761503-14509-8-git-send-email-john.stultz@linaro.org>
References: <1380761503-14509-1-git-send-email-john.stultz@linaro.org> <1380761503-14509-8-git-send-email-john.stultz@linaro.org>
From: Zhan Jianyu <nasa4836@gmail.com>
Date: Tue, 8 Oct 2013 11:27:57 +0800
Message-ID: <CAHz2CGWS+jWQU=v=5AnAgab1DrPr+snWvc62mf43Tx0aQUA8nA@mail.gmail.com>
Subject: Re: [PATCH 07/14] vrange: Purge volatile pages when memory is tight
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Minchan Kim <minchan@kernel.org>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 8:51 AM, John Stultz <john.stultz@linaro.org> wrote:
>  static inline int page_referenced(struct page *page, int is_locked,
>                                   struct mem_cgroup *memcg,
> -                                 unsigned long *vm_flags)
> +                                 unsigned long *vm_flags,
> +                                 int *is_vrange)
>  {
>         *vm_flags = 0;
> +       *is_vrange = 0;
>         return 0;
>  }

I don't know if it is appropriate to add a parameter in such a  core
function for an optional functionality. Maybe the is_vrange flag
should be squashed into the vm_flags ? I am not sure .




--

Regards,
Zhan Jianyu
