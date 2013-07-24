Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab3GXVE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 17:04:28 -0400
Received: from www.sr71.net ([198.145.64.142]:56116 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557Ab3GXVE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 17:04:26 -0400
Message-ID: <51F0414F.3060600@sr71.net>
Date: Wed, 24 Jul 2013 14:04:15 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "K. Y. Srinivasan" <kys@microsoft.com>
CC: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        andi@firstfloor.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        kamezawa.hiroyuki@gmail.com, mhocko@suse.cz, hannes@cmpxchg.org,
        yinghan@google.com
Subject: Re: [PATCH 2/2] Drivers: hv: balloon: Online the hot-added memory
 "in context"
References: <1374701355-30799-1-git-send-email-kys@microsoft.com> <1374701399-30842-1-git-send-email-kys@microsoft.com> <1374701399-30842-2-git-send-email-kys@microsoft.com>
In-Reply-To: <1374701399-30842-2-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 02:29 PM, K. Y. Srinivasan wrote:
>  		/*
> -		 * Wait for the memory block to be onlined.
> -		 * Since the hot add has succeeded, it is ok to
> -		 * proceed even if the pages in the hot added region
> -		 * have not been "onlined" within the allowed time.
> +		 * Before proceeding to hot add the next segment,
> +		 * online the segment that has been hot added.
>  		 */
> -		wait_for_completion_timeout(&dm_device.ol_waitevent, 5*HZ);
> +		online_memory_block(start_pfn);

Ahhhhh....  You've got a timeout in the code in order to tell the
hypervisor that you were successfully able to add the memory?  The
userspace addition code probably wasn't running within this timeout
period.  right?
