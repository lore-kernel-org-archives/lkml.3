Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab3JHCvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 22:51:22 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:49622 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab3JHCvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 22:51:20 -0400
Message-ID: <52537326.7000505@gmail.com>
Date: Mon, 07 Oct 2013 22:51:18 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, John Stultz <john.stultz@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
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
References: <1380761503-14509-6-git-send-email-john.stultz@linaro.org> <52533C12.9090007@zytor.com> <5253404D.2030503@linaro.org> <52534331.2060402@zytor.com> <52534692.7010400@linaro.org> <525347BE.7040606@zytor.com> <525349AE.1070904@linaro.org> <52534AEC.5040403@zytor.com> <20131008001306.GD25780@bbox> <52535EE1.3060700@zytor.com> <20131008020847.GH25780@bbox>
In-Reply-To: <20131008020847.GH25780@bbox>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe, int madvise5(addr, length, MADV_DONTNEED|MADV_LAZY|MADV_SIGBUS,
>          &purged, &ret);
>
> Another reason to make it hard is that madvise(2) is tight coupled with
> with vmas split/merge. It needs mmap_sem's write-side lock and it hurt
> anon-vrange test performance much heavily and userland might want to
> make volatile range with small unit like "page size" so it's undesireable
> to make it with vma. Then, we should filter out to avoid vma split/merge
> in implementation if only MADV_LAZY case? Doable but it could make code
> complicated and lost consistency with other variant of madvise.

I haven't seen your performance test result. Could please point out URLs?


