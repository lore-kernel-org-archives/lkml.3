Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141AbaG3Don (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 23:44:43 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:36716 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932088AbaG3Dol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 23:44:41 -0400
X-IronPort-AV: E=Sophos;i="5.00,992,1396972800"; 
   d="scan'208";a="33942982"
Message-ID: <53D86A7A.9080501@cn.fujitsu.com>
Date: Wed, 30 Jul 2014 11:46:02 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 2/2 V2] workqueue: use dedicated creater kthread for
 all pools
References: <20140729021643.GA22241@mtj.dyndns.org> <1406625376-19177-1-git-send-email-laijs@cn.fujitsu.com> <20140729150459.GE4791@htj.dyndns.org> <53D83D33.80101@cn.fujitsu.com> <20140730032334.GA15787@htj.dyndns.org>
In-Reply-To: <20140730032334.GA15787@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 11:23 AM, Tejun Heo wrote:
> Hello, Lai.
> 
> On Wed, Jul 30, 2014 at 08:32:51AM +0800, Lai Jiangshan wrote:
>>> Why?  Just sleep and retry?  What's the point of requeueing?
>>
>> Accepted your comments except this one which may need to discuss
>> for an additional round.  Requeueing passes the retry to the
>> kthread_worker and gives a change to the other pools which are also
>> creating worker.
> 
> But why is that a good idea?  The fact that creation of a worker for a
> specific pool is completely coincidental.  The failed pool itself
> isn't inherently blameable.  It was just unlucky and moving onto a
> different pool doesn't improve the chance of success in any way.  The
> only thing requeueing achieves is punishing the unlucky one by putting
> it at the back of the queue while adding complexity.

It add complexity to other things but not the code.  The code is simplified.

And failed pool is much fewer than creation which is completely coincidental,
and after cooldown time, the other pool may also create worker.

Thanks,
Lai

> 
>> This patch will be deferred until 3.19 due to some unbound patches
>> are ready soon.
> 
> We're too late for this merge window anyway.  This is a pretty
> pervasive change after all.
> 
> Thanks.
> 

