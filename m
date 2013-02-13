Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520Ab3BMHze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 02:55:34 -0500
Received: from mx0.parallels.com ([199.115.104.20]:48024 "EHLO
	mx0.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757959Ab3BMHzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 02:55:32 -0500
Message-ID: <511B46FA.1090802@parallels.com>
Date: Wed, 13 Feb 2013 11:55:38 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Anton Vorontsov <anton@enomsg.org>
CC: <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linaro-kernel@lists.linaro.org>,
        <patches@linaro.org>, <kernel-team@android.com>
Subject: Re: [PATCH] memcg: Add memory.pressure_level events
References: <20130211000220.GA28247@lizard.gateway.2wire.net> <5118C522.3070905@parallels.com> <20130213071922.GB20543@lizard.gateway.2wire.net>
In-Reply-To: <20130213071922.GB20543@lizard.gateway.2wire.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>> +void __init enable_pressure_cgroup(void)
>>> +{
>>> +	WARN_ON(cgroup_add_cftypes(&mem_cgroup_subsys,
>>> +				   vmpressure_cgroup_files));
>>> +}
>>
>> There is no functionality discovery going on here, and this is
>> conditional on nothing. Isn't it better then to just add the register +
>> read functions to memcontrol.c and add the files in the memcontrol cftype ?
> 
> I was trying to make the stuff similar to the existing CONFIG_MEMCG_SWAP
> code, which does this kind of adding files to the cgroup. But I can surely
> place files into memcontrol cftype as you suggest.
> 
> Thanks a lot for the comments!
> 
Note that swap can be command line disabled, and in that case we won't
register the files.

Then it makes sense to do it in a separate helper. If I understand your
code correctly, once it is compiled in, it will always be enabled. So I
personally think it is clearer if you register it together with the rest
of the crew.



