Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796Ab3ENPDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:03:43 -0400
Received: from mail-ye0-f172.google.com ([209.85.213.172]:60226 "EHLO
	mail-ye0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab3ENPDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:03:41 -0400
Date: Tue, 14 May 2013 08:03:35 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, akpm@linux-foundation.org,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 17/21] Percpu tag allocator
Message-ID: <20130514150335.GA6795@mtj.dyndns.org>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
 <1368494338-7069-18-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368494338-7069-18-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 06:18:54PM -0700, Kent Overstreet wrote:
> +struct tag_pool {
> +	unsigned			watermark;
> +	unsigned			nr_tags;
> +
> +	struct tag_cpu_freelist		*tag_cpu;
> +
> +	struct {
> +		/* Global freelist */
> +		unsigned		nr_free;
> +		unsigned		*free;
> +		spinlock_t		lock;
> +		struct list_head	wait;
> +	} ____cacheline_aligned;
> +};

Come on, Kent.  No comment at all in the whole posting and no
justification for the patch or explanation of use cases?

-- 
tejun
