Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbaAEQoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 11:44:17 -0500
Received: from smtp03.stone-is.org ([87.238.162.66]:51071 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbaAEQoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 11:44:15 -0500
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <52C98BCC.9040900@acm.org>
Date: Sun, 05 Jan 2014 17:43:56 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>, Jeff Mahoney <jeffm@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org,
        device-mapper development <dm-devel@redhat.com>
CC: paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, mingo@kernel.org
Subject: Re: [dm-devel] [PATCH] kobject: provide kobject_put_wait to fix module
 unload race
References: <alpine.LRH.2.02.1401021733250.27775@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1401021733250.27775@file01.intranet.prod.int.rdu2.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/14 19:06, Mikulas Patocka wrote:
> -	if (t && !t->release)
> -		pr_debug("kobject: '%s' (%p): does not have a release() "
> -			 "function, it is broken and must be fixed.\n",
> -			 kobject_name(kobj), kobj);
> -

Has it been considered to issue a warning if no release function has
been defined and free_completion == NULL instead of removing the above
debug message entirely ? I think even with this patch applied it is
still wrong to invoke kobject_put() on an object without defining a
release function.

Thanks,

Bart.

