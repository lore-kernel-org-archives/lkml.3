Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaFMNwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:52:01 -0400
Received: from mail.kernel.org ([198.145.19.201]:37141 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbaFMNv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:51:59 -0400
Date: Fri, 13 Jun 2014 15:51:50 +0200
From: Robert Richter <rric@kernel.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC v2 1/7] perf: add data_{offset,size} to user_page
Message-ID: <20140613135150.GC27560@rric.localhost>
References: <1402501310-31940-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1402501310-31940-2-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402501310-31940-2-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.06.14 18:41:44, Alexander Shishkin wrote:

> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index 853bc1c..ef95af4 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -488,9 +488,14 @@ struct perf_event_mmap_page {
>  	 * In this case the kernel will not over-write unread data.
>  	 *
>  	 * See perf_output_put_handle() for the data ordering.
> +	 *
> +	 * data_{offset,size} indicate the location and size of the perf record
> +	 * buffer within the mmapped area.
>  	 */
>  	__u64   data_head;		/* head in the data section */
>  	__u64	data_tail;		/* user-space written tail */
> +	__u64	data_offset;		/* where the buffer starts */
> +	__u64	data_size;		/* data buffer size */
>  };
>  

Yes, right. This change is useful to determine the buffer size for
existing buffers to be able to share them (e.g. persistent events).

If the buffer size is not known by userspace The mechanism would be to
mmap the header page only and later remap the buffer with the correct
buffer size determined from the header page.

If there are no objections on this patch it would be good if this
patch could be applied independently of the status of the follow on
patches.

Thanks,

-Robert
