Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab3BFQUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:20:42 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:38501 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757670Ab3BFQUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:20:39 -0500
Message-ID: <511282D1.7030200@suse.cz>
Date: Wed, 06 Feb 2013 17:20:33 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: George Spelvin <linux@horizon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rodolfo Giometti <giometti@enneenne.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] pps: Use lookup list to reduce ldisc coupling
References: <20130204010303.24971.qmail@science.horizon.com> <1360166116-30797-1-git-send-email-peter@hurleysoftware.com> <1360166116-30797-4-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1360166116-30797-4-git-send-email-peter@hurleysoftware.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2013 04:55 PM, Peter Hurley wrote:
> --- a/drivers/pps/clients/pps-ldisc.c
> +++ b/drivers/pps/clients/pps-ldisc.c
> @@ -25,17 +25,47 @@
...
> +struct pps_data {
> +	struct pps_device *pps;
> +	struct tty_struct *tty;
> +	struct list_head link;
> +};
> +
> +DEFINE_SPINLOCK(pps_lock);
> +static LIST_HEAD(pps_list);

All 4 look fine, nice cleanup. Except the lock above should be static too.

thanks,
-- 
js
suse labs
