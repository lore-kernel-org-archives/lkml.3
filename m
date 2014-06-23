Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaFWWlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 18:41:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaFWWlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 18:41:36 -0400
Date: Mon, 23 Jun 2014 15:41:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: gregkh@linuxfoundation.org, hpa@linux.intel.com,
        linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
        Andrew Lunn <andrew@lunn.ch>, Stephen Warren <swarren@wwwdotorg.org>,
        Michal Hocko <mhocko@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH v8 4/4] printk: allow increasing the ring buffer
 depending on the number of CPUs
Message-Id: <20140623154134.43ac7ab63896cd9ebcba84b6@linux-foundation.org>
In-Reply-To: <1403124337-14886-4-git-send-email-mcgrof@do-not-panic.com>
References: <1403124337-14886-1-git-send-email-mcgrof@do-not-panic.com>
	<1403124337-14886-4-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014 13:45:37 -0700 "Luis R. Rodriguez" <mcgrof@do-not-panic.com> wrote:

> ...
>
> If an increase is required the ring buffer is increased to
> +	  the next power of 2 that can fit both the minimum kernel ring buffer
> +	  (LOG_BUF_SHIFT) plus the additional worst case CPU contributions.
>
> ...
>
> +	log_buf_len_update(cpu_extra + __LOG_BUF_LEN);
> +}

I'd have expected

  total_cpu_space = minimum-per-cpu-len * nr_possible_cpus;
  log_buf_len = max(__LOG_BUF_LEN, total_cpu_space)

but here you added __LOG_BUF_LEN to total_cpu_space and I cannot work
out why.  
