Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab3HGSls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:41:48 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:62746 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab3HGSlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:41:46 -0400
Message-ID: <1375900885.2644.76.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH v3 05/11] syslog_ns: make permisiion check per user
 namespace
From: Ben Hutchings <bhutchings@solarflare.com>
To: Rui Xiang <rui.xiang@huawei.com>
CC: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <serge.hallyn@ubuntu.com>, <ebiederm@xmission.com>,
        <akpm@linux-foundation.org>, <gaofeng@cn.fujitsu.com>,
        <guz.fnst@cn.fujitsu.com>, <libo.chen@huawei.com>
Date: Wed, 7 Aug 2013 20:41:25 +0200
In-Reply-To: <1375861035-24320-6-git-send-email-rui.xiang@huawei.com>
References: <1375861035-24320-1-git-send-email-rui.xiang@huawei.com>
	 <1375861035-24320-6-git-send-email-rui.xiang@huawei.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [80.83.48.229]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20062.005
X-TM-AS-Result: No--7.183100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-07 at 15:37 +0800, Rui Xiang wrote:
> Use ns_capable to check capability in user ns,
> instead of capable function. The user ns is the
> owner of current syslog ns.
> 
> Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
> ---
>  kernel/printk.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index e508ab2..ca951e7 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -374,13 +374,13 @@ static int check_syslog_permissions(int type, bool from_file,
>  		return 0;
>  
>  	if (syslog_action_restricted(type, ns)) {
> -		if (capable(CAP_SYSLOG))
> +		if (ns_capable(ns->owner, CAP_SYSLOG))
>  			return 0;
>  		/*
>  		 * For historical reasons, accept CAP_SYS_ADMIN too, with
>  		 * a warning.
>  		 */
> -		if (capable(CAP_SYS_ADMIN)) {
> +		if (ns_capable(ns->owner, CAP_SYS_ADMIN)) {
>  			pr_warn_once("%s (%d): Attempt to access syslog with "
>  				     "CAP_SYS_ADMIN but no CAP_SYSLOG "
>  				     "(deprecated).\n",

Since CAP_SYS_ADMIN is only accepted for backward compatibility, is it
really necessary to accept it as a per-namespace capability too?

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

