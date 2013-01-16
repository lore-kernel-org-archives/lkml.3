Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab3APCKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 21:10:39 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:12444 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756818Ab3APCKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 21:10:38 -0500
X-IronPort-AV: E=Sophos;i="4.84,476,1355068800"; 
   d="scan'208";a="6594928"
Message-ID: <50F60BDE.8050304@cn.fujitsu.com>
Date: Wed, 16 Jan 2013 10:09:34 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: akpm@linux-foundation.org, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, minchan@kernel.org,
        aquini@redhat.com, wency@cn.fujitsu.com, jiang.liu@huawei.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] memory-hotplug: revert register_page_bootmem_info_node()
 to empty when platform related code is not implemented
References: <1358245203-4181-1-git-send-email-linfeng@cn.fujitsu.com> <20130115142056.GC21725@dhcp22.suse.cz>
In-Reply-To: <20130115142056.GC21725@dhcp22.suse.cz>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/16 10:09:52,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/16 10:09:53,
	Serialize complete at 2013/01/16 10:09:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On 01/15/2013 10:20 PM, Michal Hocko wrote:
>> +#else
>> > +void register_page_bootmem_info_node(struct pglist_data *pgdat)
>> > +{
>> > +	/* TODO */
>> > +}
> I think that TODO is misleading here because the function should be
> empty if !CONFIG_HAVE_BOOTMEM_INFO_NODE. I would also suggest updating
Yes, I got lost here, you are right, thanks.

> include/linux/memory_hotplug.h and removing the arch specific functions
> without any implementation. Something like (untested) patch below:
I will merge your suggestion in next version.

thanks,
linfeng
> ---
