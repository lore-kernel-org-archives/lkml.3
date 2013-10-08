Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab3JHDGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 23:06:20 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:48166 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab3JHDGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 23:06:19 -0400
X-AuditID: 9c93017e-b7bd7ae00000460c-a2-525376a9435c
Date: Tue, 8 Oct 2013 12:07:36 +0900
From: Minchan Kim <minchan@kernel.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, John Stultz <john.stultz@linaro.org>,
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
        Michel Lespinasse <walken@google.com>, Rob Clark <robdclark@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 05/14] vrange: Add new vrange(2) system call
Message-ID: <20131008030736.GA29509@bbox>
References: <5253404D.2030503@linaro.org>
 <52534331.2060402@zytor.com>
 <52534692.7010400@linaro.org>
 <525347BE.7040606@zytor.com>
 <525349AE.1070904@linaro.org>
 <52534AEC.5040403@zytor.com>
 <20131008001306.GD25780@bbox>
 <52535EE1.3060700@zytor.com>
 <20131008020847.GH25780@bbox>
 <52537326.7000505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52537326.7000505@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KOSAKI,

On Mon, Oct 07, 2013 at 10:51:18PM -0400, KOSAKI Motohiro wrote:
> >Maybe, int madvise5(addr, length, MADV_DONTNEED|MADV_LAZY|MADV_SIGBUS,
> >         &purged, &ret);
> >
> >Another reason to make it hard is that madvise(2) is tight coupled with
> >with vmas split/merge. It needs mmap_sem's write-side lock and it hurt
> >anon-vrange test performance much heavily and userland might want to
> >make volatile range with small unit like "page size" so it's undesireable
> >to make it with vma. Then, we should filter out to avoid vma split/merge
> >in implementation if only MADV_LAZY case? Doable but it could make code
> >complicated and lost consistency with other variant of madvise.
> 
> I haven't seen your performance test result. Could please point out URLs?

https://lkml.org/lkml/2013/3/12/105

-- 
Kind regards,
Minchan Kim
