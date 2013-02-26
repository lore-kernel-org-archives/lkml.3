Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759787Ab3BZIuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 03:50:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:11532 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759746Ab3BZIus convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 03:50:48 -0500
X-IronPort-AV: E=Sophos;i="4.84,739,1355068800"; 
   d="scan'208";a="6771481"
Message-ID: <512C76FE.4070109@cn.fujitsu.com>
Date: Tue, 26 Feb 2013 16:49:02 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Simon Horman <horms@verge.net.au>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] kexec: Use min_t to simplify logic
References: <512C44E4.70907@cn.fujitsu.com> <512C4881.90409@cn.fujitsu.com> <1361867881.2023.16.camel@joe-AO722>
In-Reply-To: <1361867881.2023.16.camel@joe-AO722>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/26 16:49:53,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/26 16:49:56
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年02月26日 16:38, Joe Perches 写道:
> On Tue, 2013-02-26 at 13:30 +0800, Zhang Yanfei wrote:
>> This is just a tweak: using min_t to simplify logic of variable
>> assignments.
>>
>> v3:
>> - cast type of (PAGE_SIZE - (maddr & ~PAGE_MASK)) into size_t.
> 
> Why?  Isn't this just a redundant cast?
> 
>> diff --git a/kernel/kexec.c b/kernel/kexec.c
> []
>> @@ -822,13 +822,9 @@ static int kimage_load_normal_segment(struct kimage *image,
> []
>> +		mchunk = min_t(size_t, mbytes,
>> +			       (size_t)(PAGE_SIZE - (maddr & ~PAGE_MASK)));
> 
> #define min_t(type, x, y) ({			\
> 	type __min1 = (x);			\
> 	type __min2 = (y);			\
> 	__min1 < __min2 ? __min1: __min2; })
> 
> 
> 

Hmm, from the definition, the cast is redundant.

Maybe I misunderstood what Andrew meant in the mail related to v2:

"The types of PAGE_SIZE and PAGE_MASK are vague - iirc they once had
different types on different architectures, so some form of casting is
unavoidable here."

Andrew, could you please explain the casting you meant above?

Thanks
Zhang
