Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab3BRUtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 15:49:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043Ab3BRUtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 15:49:04 -0500
Date: Mon, 18 Feb 2013 15:48:58 -0500
From: Don Zickus <dzickus@redhat.com>
To: anish kumar <anish198519851985@gmail.com>
Cc: akpm@linux-foundation.org, mingo@kernel.org, chuansheng.liu@intel.com,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [Watchdog][Trivial] Added comments to explain
 watchdog_disabled variable
Message-ID: <20130218204858.GB98867@redhat.com>
References: <1361016849-5181-1-git-send-email-anish198519851985@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361016849-5181-1-git-send-email-anish198519851985@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2013 at 05:44:09PM +0530, anish kumar wrote:
> From: anish kumar <anish198519851985@gmail.com>
> 
> This watchdog_disabled flag is bit of cryptic.Howerver it's usefullnes is multifold.
> Uses are:
> 1. Check if smpboot_register_percpu_thread function passed.
> 2. Makes sure that user enables and disables the watchdog in sequence
>    i.e. enable watchdog->disable watchdog->enable watchdog
>    Unlike enable watchdog->enable watchdog which is wrong.
> 
> Signed-off-by: anish kumar <anish198519851985@gmail.com>
> ---
>  kernel/watchdog.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 75a2ab3..8a20ebe 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -518,6 +518,11 @@ int proc_dowatchdog(struct ctl_table *table, int write,
>  		return ret;
>  
>  	set_sample_period();
> +	/*
> +	 * Watchdog threads shouldn't be enabled if they are
> +	 * disabled.'watchdog_disabled' variable check in

Missing a 'The'  ^^^

Other than that,

Acked-by: Don Zickus <dzickus@redhat.com>
