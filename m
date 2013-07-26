Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab3GZDnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 23:43:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:7808 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756302Ab3GZDnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 23:43:13 -0400
X-IronPort-AV: E=Sophos;i="4.89,748,1367942400"; 
   d="scan'208";a="8029854"
Message-ID: <51F1F138.2060902@cn.fujitsu.com>
Date: Fri, 26 Jul 2013 11:47:04 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: clear workers of a pool after the CPU is offline
References: <1374749531-16423-1-git-send-email-laijs@cn.fujitsu.com> <20130725153121.GF26107@mtj.dyndns.org> <51F1DB45.90905@cn.fujitsu.com> <20130726030711.GA30195@mtj.dyndns.org>
In-Reply-To: <20130726030711.GA30195@mtj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/26 11:41:07,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/26 11:41:07,
	Serialize complete at 2013/07/26 11:41:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2013 11:07 AM, Tejun Heo wrote:
> Hello,
> 
> On Fri, Jul 26, 2013 at 10:13:25AM +0800, Lai Jiangshan wrote:
>>> Hmmm... if I'm not confused, now the cpu pools just behave like a
>>> normal unbound pool when the cpu goes down,
>>
>> cpu pools are always referenced, they don't behave like unbound pool.
> 
> Yeah sure, they don't get destroyed but pool management functions the
> same.
> 
>>> which means that the idle
>>> cpu workers will exit once idle timeout is reached, right? 
>>
>> No, no code to force the cpu workers quit currently.
>> you can just offline a cpu to see what happened to the workers.
> 
> Hmmm?  The idle timer thing doesn't work?  Why?
> 

any worker can't kill itself.
managers always tries to leave 2 workers.

so the workers of the offline cpu pool can't be totally destroyed.

(In old days, we also have idle timer, but the last workers are killed by trustee_thread())
