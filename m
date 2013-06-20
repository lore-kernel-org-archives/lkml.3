Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab3FTVF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 17:05:27 -0400
Received: from mx2.corp.phx1.mozilla.com ([63.245.216.70]:54359 "EHLO
	smtp.mozilla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757957Ab3FTVF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 17:05:26 -0400
Message-ID: <51C36E91.2020509@mozilla.com>
Date: Thu, 20 Jun 2013 17:05:21 -0400
From: Dhaval Giani <dgiani@mozilla.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>, Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 5/8] vrange: Add new vrange(2) system call
References: <1371010971-15647-1-git-send-email-john.stultz@linaro.org> <1371010971-15647-6-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1371010971-15647-6-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-06-12 12:22 AM, John Stultz wrote:
> From: Minchan Kim <minchan@kernel.org>
>
> This patch adds new system call sys_vrange.
>
> NAME
> 	vrange - Mark or unmark range of memory as volatile
>
> SYNOPSIS
> 	int vrange(unsigned_long start, size_t length, int mode,
> 			 int *purged);
>
> DESCRIPTION
> 	Applications can use vrange(2) to advise the kernel how it should
> 	handle paging I/O in this VM area.  The idea is to help the kernel
> 	discard pages of vrange instead of reclaiming when memory pressure
> 	happens. It means kernel doesn't discard any pages of vrange if
> 	there is no memory pressure.
>
> 	mode:
> 	VRANGE_VOLATILE
> 		hint to kernel so VM can discard in vrange pages when
> 		memory pressure happens.
> 	VRANGE_NONVOLATILE
> 		hint to kernel so VM doesn't discard vrange pages
> 		any more.
>
> 	If user try to access purged memory without VRANGE_NOVOLATILE call,
> 	he can encounter SIGBUS if the page was discarded by kernel.

I wonder if it would be possible to provide additional information here, 
for example "purge range at a time" as opposed to "purge page at a 
time". There are some valid use cases for both approaches and it doesn't 
make sense to deny one use case.

Thanks!
Dhaval
