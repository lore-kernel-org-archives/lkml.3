Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab3ENOsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:48:47 -0400
Received: from mx2.parallels.com ([199.115.105.18]:37701 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab3ENOso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:48:44 -0400
Message-ID: <51924EE3.9020708@parallels.com>
Date: Tue, 14 May 2013 18:49:07 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Andrey Vagin <avagin@openvz.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] memcg: don't initialize kmem-cache destroying work for
 root caches
References: <1368535118-27369-1-git-send-email-avagin@openvz.org> <20130514144031.GR5198@dhcp22.suse.cz> <20130514144427.GS5198@dhcp22.suse.cz>
In-Reply-To: <20130514144427.GS5198@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 06:44 PM, Michal Hocko wrote:
> On Tue 14-05-13 16:40:31, Michal Hocko wrote:
>> On Tue 14-05-13 16:38:38, Andrey Vagin wrote:
>>> struct memcg_cache_params has a union. Different parts of this union are
>>> used for root and non-root caches. A part with destroying work is used only
>>> for non-root caches.
>>
>> but memcg_update_cache_size is called only for !root caches AFAICS
>> (check memcg_update_all_caches)
> 
> Ohh, I am blind. memcg_update_all_caches skips all !root caches.
> Then the patch looks correct. If Glauber has nothing against then thise
> should be marked for stable (3.9)
> 
This was recently introduced by the commit that moved the initialization
earlier (15cf17d26e08ee9). It basically moved too much, and I didn't
catch it. If that patch is in 3.9, then yes, this needs to go to stable.
Otherwise it is not affected.

However, I do remember Andrey telling me that he hit this bug in both
3.9 and 3.10-rc1, so yes, stable it is.

