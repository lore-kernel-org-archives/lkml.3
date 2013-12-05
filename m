Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab3LEIE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 03:04:29 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:33171 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab3LEIE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 03:04:28 -0500
Date: Thu, 5 Dec 2013 11:00:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: gregkh@linuxfoundation.org, arve@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        ccross@android.com, Dave.Butcher@arm.com, irogers@google.com,
        romlem@android.com
Subject: Re: [PATCH v1 1/9] staging: android: binder: Move some of the logic
 into subfunction
Message-ID: <20131205080050.GT28413@mwanda>
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
 <1386180581-6710-2-git-send-email-serban.constantinescu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386180581-6710-2-git-send-email-serban.constantinescu@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 06:09:33PM +0000, Serban Constantinescu wrote:
> +static void bc_dead_binder_done(struct binder_proc *proc,
> +		    struct binder_thread *thread, void __user *cookie)
> +{
> +	struct binder_work *w;
> +	struct binder_ref_death *death = NULL;
> +
> +	list_for_each_entry(w, &proc->delivered_death, entry) {
> +		struct binder_ref_death *tmp_death = container_of(w, struct binder_ref_death, work);

Put a blank line after the variable declaration block.  Also break it up
into two lines instead of having the lines be a million characters long.

	list_for_each_entry(w, &proc->delivered_death, entry) {
		struct binder_ref_death *tmp_death;

		tmp_death = container_of(w, struct binder_ref_death, work);

> +		if (tmp_death->cookie == cookie) {
> +			death = tmp_death;
> +			return;

Should be a break here.  This function wasn't tested.

> +		}
> +	}

regards,
dan carpenter

