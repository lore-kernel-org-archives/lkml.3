Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbaFMVmH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 17:42:07 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:5118 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaFMVmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 17:42:06 -0400
Message-ID: <1402695712.27369.10.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v3] printk: allow increasing the ring buffer depending
 on the number of CPUs
From: Davidlohr Bueso <davidlohr@hp.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: hpa@linux.intel.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
        Michal Hocko <mhocko@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>, Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 13 Jun 2014 14:41:52 -0700
In-Reply-To: <1402684097-5731-1-git-send-email-mcgrof@do-not-panic.com>
References: <1402684097-5731-1-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-13 at 11:28 -0700, Luis R. Rodriguez wrote:
> +	/*
> +	 * If you set log_buf_len=n kernel parameter LOG_CPU_MIN_BUF_SHIFT will
> +	 * be ignored. LOG_CPU_MIN_BUF_SHIFT is a proactive measure for large
> +	 * systems. With a LOG_BUF_SHIFT of 18 and LOG_CPU_MIN_BUF_SHIFT 12 at
> +	 * we'd require more than 64 CPUs to trigger an increase from the
> +	 * default.
> +	 */
> +	if (!new_log_buf_len && (cpu_extra > __LOG_BUF_LEN / 2))
             ^ that ! looks wrong. We should be checking for log_buf_len set instead.

> +		new_log_buf_len = __LOG_BUF_LEN + cpu_extra;

You could also move the whole thing below the return statement, that way
we can avoid double checking new_log_buf_len. Otherwise looks kinda
weird.
>  
>  	if (!new_log_buf_len)
>  		return;

Thanks,
Davidlohr

