Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990Ab3EXDFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 23:05:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:20133 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759771Ab3EXDFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 23:05:54 -0400
X-IronPort-AV: E=Sophos;i="4.87,731,1363104000"; 
   d="scan'208";a="7351504"
Message-ID: <519ED883.9060903@cn.fujitsu.com>
Date: Fri, 24 May 2013 11:03:31 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Stephen Mell <sub.atomic.fusion@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: move proc mount options out of pid_namespace
References: <3342521.NtikuogILA@pegasus> <519DED89.9000409@cn.fujitsu.com> <2515335.Kvy7Q1OKc4@pegasus>
In-Reply-To: <2515335.Kvy7Q1OKc4@pegasus>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/24 11:04:31,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/24 11:04:32,
	Serialize complete at 2013/05/24 11:04:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 05/24/2013 07:32 AM, Stephen Mell wrote:

> On Thursday, May 23, 2013 18:20:57 Gu Zheng wrote:
> 
>> Here it'll create a new proc sb instance which holds the same context as the old ones
>> each time we mount proc though in the same PID namespace, won't it?
> I believe so. But this is the point, right? 

Yes, but I think it's also the problem.

>They won't be identical if different mount options are used, I don't think.

If different mount options are used, we'll create different super block instance, and they have
the same context, only the difference is each one holds different proc_sb_info.
But I think what we really want is only one proc sb instance and create different proc_sb_info
if different mount options are used.

> 
>> Here the pre-check seems needless.
> Is that new with my patch, or has it always been needless?

Yeah, it's always needless.

Thanks,
Gu

> 
> Thanks,
> Stephen
> 


