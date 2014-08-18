Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbaHRJIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:08:05 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:61941 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaHRJID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:08:03 -0400
Date: Mon, 18 Aug 2014 11:07:57 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: akpm@linux-foundation.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mingo@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Ulrich Obergfell <uobergfe@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 3/5] watchdog: fix print-once on enable
Message-ID: <20140818090757.GC25495@gmail.com>
References: <1407768567-171794-1-git-send-email-dzickus@redhat.com>
 <1407768567-171794-4-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407768567-171794-4-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -522,6 +522,9 @@ static void watchdog_nmi_disable(unsigned int cpu)
>  		/* should be in cleanup, but blocks oprofile */
>  		perf_event_release_kernel(event);
>  	}
> +	if (cpu == 0)
> +		/* watchdog_nmi_enable() expects this to be zero initially. */
> +		cpu0_err = 0;
>  	return;
>  }

While at it I also removed the stray 'return;'.

Thanks,

	Ingo
