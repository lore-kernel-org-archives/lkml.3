Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab3FNJll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 05:41:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:4664 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab3FNJlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 05:41:39 -0400
X-IronPort-AV: E=Sophos;i="4.87,864,1363104000"; 
   d="scan'208";a="7547104"
Message-ID: <51BAE4A5.6070506@cn.fujitsu.com>
Date: Fri, 14 Jun 2013 17:38:45 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Andrew Shewmaker <agshew@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Namjae Jeon <linkinjeon@gmail.com>, Jan Kara <jack@suse.cz>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] mm/writeback: fix wb_do_writeback exported unsafely
References: <1371195041-26654-1-git-send-email-liwanp@linux.vnet.ibm.com> <20130614090217.GA7574@dhcp22.suse.cz> <20130614092952.AAED5E0090@blue.fi.intel.com> <20130614093159.GB10084@dhcp22.suse.cz>
In-Reply-To: <20130614093159.GB10084@dhcp22.suse.cz>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/14 17:39:40,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/14 17:39:41,
	Serialize complete at 2013/06/14 17:39:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 05:31 PM, Michal Hocko wrote:
> On Fri 14-06-13 12:29:52, Kirill A. Shutemov wrote:
>> Michal Hocko wrote:
>>> On Fri 14-06-13 15:30:34, Wanpeng Li wrote:
>>>> There is just one caller in fs-writeback.c call wb_do_writeback and
>>>> current codes unnecessary export it in header file, this patch fix
>>>> it by changing wb_do_writeback to static function.
>>>
>>> So what?
>>>
>>> Besides that git grep wb_do_writeback tells that 
>>> mm/backing-dev.c:                       wb_do_writeback(me, 0);
>>>
>>> Have you tested this at all?
>>
>> Commit 839a8e8 removes that.
> 
> OK, I didn't check the most up-to-date tree. Sorry about this confusion.
> I do not object to cleanups like this but it should be clear they are
> cleanups. "fix wb_do_writeback exported unsafely" sounds like a fix
> rather than a cleanup

Agreed.

> 
>>>> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
>>
>> Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>>
>> -- 
>>  Kirill A. Shutemov
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 


-- 
Thanks.
Zhang Yanfei
