Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbaEOSOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:14:12 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:46503 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbaEOSOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:14:10 -0400
Date: Thu, 15 May 2014 20:14:02 +0200
From: Robert Richter <rric@kernel.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC 1/2] perf: add data_{offset,size} to user_page
Message-ID: <20140515181402.GB7541@rric.localhost>
References: <1400166510-9234-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1400166510-9234-2-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400166510-9234-2-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.05.14 18:08:29, Alexander Shishkin wrote:
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

Yeah, we need something like this also for other reasons. For
persistent events we don't know the buffer size when mmaping
existing/shared buffers. To determine the buffer size we could map the
first page only, read the size and then mremap() to the actual size.

Please keep this use case in mind too, also for the aux buffer. The
best would be if data_size is the mmap size.

Thanks,

-Robert
