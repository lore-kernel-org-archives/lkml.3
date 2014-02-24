Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbaBXQ5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:57:44 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:37493 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbaBXQ5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:57:42 -0500
Date: Mon, 24 Feb 2014 08:57:38 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: minyard@acm.org
Cc: OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Russ Anderson <rja@sgi.com>,
        Matthew Garrett <matthew.garrett@nebula.com>, lenb@kernel.org,
        rjw@rjwysocki.net, linux-acpi@vger.kernel.org,
        Corey Minyard <cminyard@mvista.com>
Subject: Re: [PATCH 2/3] ipmi: Turn off all activity on an idle ipmi interface
Message-ID: <20140224165738.GB26479@core.coreip.homeip.net>
References: <1393208616-16500-1-git-send-email-minyard@acm.org>
 <1393208616-16500-3-git-send-email-minyard@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393208616-16500-3-git-send-email-minyard@acm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 23, 2014 at 08:23:35PM -0600, minyard@acm.org wrote:
> @@ -1194,7 +1223,17 @@ int ipmi_set_gets_events(ipmi_user_t user, int val)
>  	INIT_LIST_HEAD(&msgs);
>  
>  	spin_lock_irqsave(&intf->events_lock, flags);
> -	user->gets_events = val;
> +	if (user->gets_events == !!val)
> +		goto out;
> +
> +	user->gets_events = !!val;

Why not have val declared as bool and let compiler convert as needed?

Thanks.

-- 
Dmitry
