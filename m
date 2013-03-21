Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab3CULGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:06:19 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:42300 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358Ab3CULGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:06:17 -0400
Message-ID: <514AE9A3.5090209@openvz.org>
Date: Thu, 21 Mar 2013 15:06:11 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130119 Firefox/10.0.11esrpre Iceape/2.7.12
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: Michal Marek <mmarek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RFC 1/5] kconfig: implement weak reverse-dependencies
References: <20130321082256.21557.68351.stgit@zurg> <20130321102200.GB2341@netboy.at.omicron.at>
In-Reply-To: <20130321102200.GB2341@netboy.at.omicron.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Cochran wrote:
> On Thu, Mar 21, 2013 at 12:22:57PM +0400, Konstantin Khlebnikov wrote:
>> This patch adds new kind of dependencies between kconfig symbols,
>> and new kconfig keyword 'apply' for them.
>>
>> 'apply' works mostly like 'select', but it allows to disable target symbol.
>> Thus target symbol will be either disabled or reachable from current symbol.
>>
>> This method allows to implement optional dependencies without introducing new
>> kconfig symbol for each pair of connected kconfig options.
>
> I don't really understand what the point of this new keyword is, but I
> wonder why you chose PTP Hardware Clocks as your Guinea pig.
>
> As discussed on the netdev list [1][2], the consensus was that if a
> MAC driver has a PHC, then it should always be compiled in.

I don't like situations when really optional code becomes mandatory.

As I see this technology requires special dedicated server in the local
network, thus it's unusable in most situations. But it starts working
without any actions from the user (please fix me if I'm wrong).

Thus this code enables some rarely used parts of hardware.
After seeing several weird bugs in ethernet devices I prefer to
keep unused/unwanted features off.

>
> And BTW, please CC netdev for PHC patches.

Of course, if basic logic of this RFC patchset will be approved I'll resend
PTP part to netdev. I don't want to bother netdev guys because PTP and e1000e
are used here just as Guinea pigs.

>
> Thanks,
> Richard
>
> 1. http://marc.info/?l=linux-netdev&m=135173341101960
> 2. http://www.spinics.net/lists/netdev/msg215379.html

