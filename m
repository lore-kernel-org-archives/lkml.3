Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934152Ab3GWUIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 16:08:21 -0400
Received: from www.sr71.net ([198.145.64.142]:45209 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757881Ab3GWUIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 16:08:18 -0400
Message-ID: <51EEE2A6.60109@sr71.net>
Date: Tue, 23 Jul 2013 13:08:06 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Bob Liu <bob.liu@oracle.com>, Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <lliubbo@gmail.com>, Minchan Kim <minchan@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: zswap: add runtime enable/disable
References: <1374521642-25478-1-git-send-email-sjenning@linux.vnet.ibm.com> <51EE49D7.4060501@oracle.com> <20130723173223.GB5820@medulla.variantweb.net>
In-Reply-To: <20130723173223.GB5820@medulla.variantweb.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 10:32 AM, Seth Jennings wrote:
> On Tue, Jul 23, 2013 at 05:16:07PM +0800, Bob Liu wrote:
>> On 07/23/2013 03:34 AM, Seth Jennings wrote:
>>> -To enabled zswap, the "enabled" attribute must be set to 1 at boot time.  e.g.
>>> -zswap.enabled=1
>>> +Zswap is disabled by default but can be enabled at boot time by setting
>>> +the "enabled" attribute to 1 at boot time. e.g. zswap.enabled=1.  Zswap
>>> +can also be enabled and disabled at runtime using the sysfs interface.
>>> +An exmaple command to enable zswap at runtime, assuming sysfs is mounted
>>> +at /sys, is:
>>> +
>>> +echo 1 > /sys/modules/zswap/parameters/enabled
>>> +
>>> +When zswap is disabled at runtime, it will stop storing pages that are
>>> +being swapped out.  However, it will _not_ immediately write out or
>>> +fault back into memory all of the pages stored in the compressed pool.
>>
>> I don't know what's you use case of adding this feature.
> 
> Dave expressed interest in having it, useful for testing, and I can see
> people that just wanting to try it out enabling it manually at runtime.

The distributions are going to have to make a decision about whether or
not they turn this on.  If it is 100% selected at compile-time and has
all of the potential performance implications (zswap *can* hurt with
certain workloads), I would not expect a distribution to enable it at all.

The only sane thing to do here is to compile it in, runtime-default it
to off, and let folks enable it who want to use it on their workload.

>> In my opinion I'd perfer to flush all the pages stored in zswap when
>> disabled it, so that I can run testing without rebooting the machine.
> 
> Why would you have to reboot your machine?  If you want to force all
> the pages out of the compressed pool, a swapoff should do it as now
> noted in the Documentation file (below).

It is kinda crummy that it won't be flushed, but considering the size
and simplicity of the patch as it stands, I'm not going to whinge about
it too much.

Seth, it'd be nice to have you at least see if it is worth flushing all
the pages when zswap is disabled, or whether it's too much code to go to
the trouble.
