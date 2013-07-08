Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab3GHSsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 14:48:07 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:57809 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab3GHSsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 14:48:06 -0400
Message-ID: <51DB0962.50209@gmail.com>
Date: Mon, 08 Jul 2013 14:48:02 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] mm: Honor min_free_kbytes set by user
References: <1372954036-16988-1-git-send-email-mhocko@suse.cz> <1372954239.1886.40.camel@joe-AO722> <20130704161641.GD7833@dhcp22.suse.cz> <20130704162005.GE7833@dhcp22.suse.cz>
In-Reply-To: <20130704162005.GE7833@dhcp22.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Checkpatch fixes
> ---
>  From 5f089c0b2a57ff6c08710ac9698d65aede06079f Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Thu, 4 Jul 2013 17:15:54 +0200
> Subject: [PATCH] mm: Honor min_free_kbytes set by user
>
> min_free_kbytes is updated during memory hotplug (by init_per_zone_wmark_min)
> currently which is right thing to do in most cases but this could be
> unexpected if admin increased the value to prevent from allocation
> failures and the new min_free_kbytes would be decreased as a result of
> memory hotadd.
>
> This patch saves the user defined value and allows updating
> min_free_kbytes only if it is higher than the saved one.
>
> A warning is printed when the new value is ignored.
>
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Thank you. I have similar patch and I have been bothered long time to
refine and post it.
Yes, current logic is not memory hotplug aware and could be dangerous.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>






