Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaKJMSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:18:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:17741 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512AbaKJMSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:18:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="486165240"
Message-ID: <1415621918.22887.80.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBI: Extend UBI layer debug/messaging capabilities -
 cosmetics
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: hujianyang@huawei.com, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Mon, 10 Nov 2014 14:18:38 +0200
In-Reply-To: <1415531185-2343-1-git-send-email-tlinder@codeaurora.org>
References: <1415531185-2343-1-git-send-email-tlinder@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-11-09 at 13:06 +0200, Tanya Brokhman wrote:
>  
>  /* Normal UBI messages */
>  #define ubi_msg(ubi, fmt, ...) pr_notice("UBI-%d: %s:" fmt "\n", \
> -                                        ubi->ubi_num, __func__, ##__VA_ARGS__)
> +                               (ubi ? ubi->ubi_num : UBI_MAX_DEVICES), \
> +                               __func__, ##__VA_ARGS__)
>  /* UBI warning messages */
>  #define ubi_warn(ubi, fmt, ...) pr_warn("UBI-%d warning: %s: " fmt "\n", \
> -                                       ubi->ubi_num, __func__, ##__VA_ARGS__)
> +                               (ubi ? ubi->ubi_num : UBI_MAX_DEVICES), \
> +                               __func__, ##__VA_ARGS__)
>  /* UBI error messages */
>  #define ubi_err(ubi, fmt, ...) pr_err("UBI-%d error: %s: " fmt "\n", \
> -                                     ubi->ubi_num, __func__, ##__VA_ARGS__)
> +                               (ubi ? ubi->ubi_num : UBI_MAX_DEVICES), \
> +                               __func__, ##__VA_ARGS__)

Why did you make these changes? It is preferable to not add another 'if'
statement to this macro to handle one or 2 cases - much bloat, little
gain.

Could we please avoid this?

>  
> -       if (!ubi->free.rb_node || (ubi->free_count - ubi->beb_rsvd_pebs < 1)) {
> -               ubi_warn(ubi, "Can't get peb for fastmap:anchor=%d, free_cnt=%d, reserved=%d",
> -                        anchor, ubi->free_count, ubi->beb_rsvd_pebs);
> +       if (!ubi->free.rb_node || (ubi->free_count - ubi->beb_rsvd_pebs < 1))
>                 goto out;

The warning looks pretty poor, so I do not mind to remove it, but I
thought your patch is about adding a parameter, but you mix different
kinds of things there. Please, be stricter to the similar UBIFS patch
which you was going to send.


> -               if (kthread_should_stop()) {
> -                       ubi_msg(ubi, "background thread \"%s\" should stop, PID %d",
> -                               ubi->bgt_name, task_pid_nr(current));
> +               if (kthread_should_stop())
>                         break;
> -               }

How about just turning this into a debug message, not removing?

Artem.

