Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbaJSAjw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 20:39:52 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42782 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaJSAjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 20:39:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: akpm@linux-foundation.org, mingo@kernel.org,
        Mark Rustad <mark.d.rustad@intel.com>, linux-kernel@vger.kernel.org
References: <1413286868-21870-1-git-send-email-jeffrey.t.kirsher@intel.com>
Date: Sat, 18 Oct 2014 17:39:10 -0700
In-Reply-To: <1413286868-21870-1-git-send-email-jeffrey.t.kirsher@intel.com>
	(Jeff Kirsher's message of "Tue, 14 Oct 2014 04:41:08 -0700")
Message-ID: <87a94szydt.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18WCpwvaCtOYWDo5C9QrfhohZXLKjtXJYo=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4891]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeff Kirsher <jeffrey.t.kirsher@intel.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 330 ms - load_scoreonly_sql: 0.05 (0.0%),
	signal_user_changed: 3.5 (1.1%), b_tie_ro: 2.5 (0.8%), parse: 0.73 (0.2%),
	extract_message_metadata: 17 (5.2%), get_uri_detail_list: 1.66 (0.5%),
	tests_pri_-1000: 6 (1.7%), tests_pri_-950: 1.47 (0.4%), tests_pri_-900: 1.23
	(0.4%), tests_pri_-400: 18 (5.3%), check_bayes: 16 (5.0%), b_tokenize: 6
	(1.7%), b_tok_get_all: 5 (1.6%), b_comp_prob: 1.53 (0.5%), b_tok_touch_all:
	1.97 (0.6%), b_finish: 0.68 (0.2%), tests_pri_0: 272 (82.4%), tests_pri_500:
	7 (2.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] kernel/sysctl: Resolve missing-field-initializers warnings
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Kirsher <jeffrey.t.kirsher@intel.com> writes:

> From: Mark Rustad <mark.d.rustad@intel.com>
>
> Resolve missing-field-initializers warnings in W=2 builds by
> using designated initialization.

ick.  No.

That gcc warning makes no sense.  In this case heeding it makes the code
significantly uglier and significantly more confusing.

Eric


> Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
>  kernel/sysctl.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 4aada6d..5623845 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -257,7 +257,7 @@ static struct ctl_table sysctl_base_table[] = {
>  		.mode		= 0555,
>  		.child		= dev_table,
>  	},
> -	{ }
> +	{ .procname = NULL }
>  };
>  
>  #ifdef CONFIG_SCHED_DEBUG
> @@ -1103,7 +1103,7 @@ static struct ctl_table kern_table[] = {
>  		.proc_handler	= proc_dointvec,
>  	},
>  #endif
> -	{ }
> +	{ .procname = NULL }
>  };
>  
>  static struct ctl_table vm_table[] = {
> @@ -1485,12 +1485,12 @@ static struct ctl_table vm_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= proc_doulongvec_minmax,
>  	},
> -	{ }
> +	{ .procname = NULL }
>  };
>  
>  #if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
>  static struct ctl_table binfmt_misc_table[] = {
> -	{ }
> +	{ .procname = NULL }
>  };
>  #endif
>  
> @@ -1658,7 +1658,7 @@ static struct ctl_table fs_table[] = {
>  		.proc_handler	= &pipe_proc_fn,
>  		.extra1		= &pipe_min_size,
>  	},
> -	{ }
> +	{ .procname = NULL }
>  };
>  
>  static struct ctl_table debug_table[] = {
> @@ -1682,11 +1682,11 @@ static struct ctl_table debug_table[] = {
>  		.extra2		= &one,
>  	},
>  #endif
> -	{ }
> +	{ .procname = NULL }
>  };
>  
>  static struct ctl_table dev_table[] = {
> -	{ }
> +	{ .procname = NULL }
>  };
>  
>  int __init sysctl_init(void)
