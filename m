Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab3JCMPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 08:15:19 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60000 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab3JCMPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 08:15:17 -0400
Date: Thu, 3 Oct 2013 14:15:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        aswin@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lockstat: report avg wait and hold times
Message-ID: <20131003121513.GA6760@gmail.com>
References: <1380746928.2313.14.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380746928.2313.14.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Davidlohr Bueso <davidlohr@hp.com> wrote:

> While both the nr and total times are showed, having the avg lock hold
> and wait times show in the report is quite useful when working on
> performance related issues. Furthermore, I find myself constantly
> doing the calculations manually.
> 
> In addition, some of the documentation examples were changed to easily
> update them to show the two new columns. No textual change otherwise,
> as descriptions match the lockstat output.

Looks useful.

> --- a/kernel/lockdep_proc.c
> +++ b/kernel/lockdep_proc.c
> @@ -421,6 +421,7 @@ static void seq_lock_time(struct seq_file *m, struct lock_time *lt)
>  	seq_time(m, lt->min);
>  	seq_time(m, lt->max);
>  	seq_time(m, lt->total);
> +	seq_time(m, lt->nr ? lt->total/lt->nr : 0);

That won't build on 32-bit systems as lt->total is s64.

You'll need to utilize do_div().

Thanks,

	Ingo
