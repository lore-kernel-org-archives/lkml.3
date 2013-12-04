Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab3LDJDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:03:43 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:40086 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab3LDJDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 04:03:40 -0500
Date: Wed, 4 Dec 2013 10:03:36 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        ak@linux.intel.com, jolsa@redhat.com, zheng.z.yan@intel.com
Subject: Re: [PATCH] perf/x86: fix bug in event constraint end marker macro
Message-ID: <20131204090336.GA31973@gmail.com>
References: <20131204090028.GA9724@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204090028.GA9724@quad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

>  #define EVENT_CONSTRAINT_END		\
> -	EVENT_CONSTRAINT(0, 0, 0)
> +	{ .idxmsk64 = 0,		\
> +	  .code = 0,			\
> +	  .cmask = 0,			\
> +	  .weight = -1,			\
> +	  .overlap = 0,			\
> +	  .flags = 0,			\
> +}

A nit, simply writing:

#define EVENT_CONSTRAINT_END { .weight = -1, }

... should be enough as initialization to zero is guaranteed for the 
other fields.

Thanks,

	Ingo
