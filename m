Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab3BOWox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 17:44:53 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357Ab3BOWow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 17:44:52 -0500
Date: Fri, 15 Feb 2013 23:44:44 +0100
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com,
        davej@redhat.com, keescook@chromium.org, stable@vger.kernel.org,
        tglx@linutronix.de, gorcunov@openvz.org, ebiederm@xmission.com
Subject: Re: + futex-avoid-kernel-taint-caused-by-get_robust_list.patch
 added to -mm tree
Message-ID: <20130215234444.29345fc3@spider.haslach.nod.at>
In-Reply-To: <20130215222653.B8B115A41F0@corp2gmr1-2.hot.corp.google.com>
References: <20130215222653.B8B115A41F0@corp2gmr1-2.hot.corp.google.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Fri, 15 Feb 2013 14:26:52 -0800
schrieb akpm@linux-foundation.org:
> ------------------------------------------------------
> From: Paul Gortmaker <paul.gortmaker@windriver.com>
> Subject: futex: avoid kernel taint caused by get_robust_list
> 
> Commit ec0c4274e33c0373e4 ("futex: Mark get_robust_list as
> deprecated") added these two WARN_ONCE calls.
> 
> However, WARN_ONCE taints the kernel, and we shouldn't be allowing any
> user who wanders by to do this.  For example, the system fuzzer
> "trinity" uses the tainted state as a metric for when to stop,
> assuming that it has caused significant wreckage (and indeed that
> tool is what actually led me to this change).
> 
> The ability to deprecate this code has been called into question[1],
> but if that remains to be finalized, then making this change in the
> interim seems to make sense.

Do we really want to remove this system call in 2013?
Note, Documentation/feature-removal-schedule.txt is gone...

CRIU folks, I guess you still need the call?
Or have you found an alternative way to get the robost list?

As stated in [0], I'd simply revert commit ec0c4274 ("futex: Mark
get_robust_list as deprecated")

Thanks,
//richard

[0] http://permalink.gmane.org/gmane.linux.kernel.hardened.devel/506
