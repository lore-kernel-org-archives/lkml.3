Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab3BEJA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:00:26 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:37699 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab3BEJAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:00:25 -0500
X-IronPort-AV: E=Sophos;i="4.84,603,1355068800"; 
   d="scan'208";a="6691571"
Message-ID: <5110C28D.1040001@cn.fujitsu.com>
Date: Tue, 05 Feb 2013 16:27:57 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: akpm@linux-foundation.org, mgorman@suse.de, bcrl@kvack.org,
        viro@zeniv.linux.org.uk, khlebnikov@openvz.org, walken@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, rientjes@google.com,
        isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, jiang.liu@huawei.com, linux-mm@kvack.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm: hotplug: implement non-movable version of get_user_pages()
 to kill long-time pin pages
References: <1359972248-8722-1-git-send-email-linfeng@cn.fujitsu.com> <20130205005859.GE2610@blaptop> <51108DC8.4090704@cn.fujitsu.com> <20130205052517.GH2610@blaptop> <5110A442.5000707@cn.fujitsu.com> <20130205074519.GB11197@blaptop>
In-Reply-To: <20130205074519.GB11197@blaptop>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/05 16:28:01,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/05 16:28:08,
	Serialize complete at 2013/02/05 16:28:08
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan,

On 02/05/2013 03:45 PM, Minchan Kim wrote:
>> So it may not a good idea that we all fall into calling the *non_movable* version of
>> > GUP when CONFIG_MIGRATE_ISOLATE is on. What do you think?
> Frankly speaking, I can't understand Mel's comment.
> AFAIUC, he said GUP checks the page before get_page and if the page is movable zone,
> then migrate it out of movable zone and get_page again.
> That's exactly what I want. It doesn't introduce GUP_NM.
Since an long time pin or not is an unpredictable behave except you know what the caller
wants to do. We have to check every time we call GUP, and GUP may need another parameter
 to teach itself to make the right decision? We have already got *8* parameters :(

thanks,
linfeng
