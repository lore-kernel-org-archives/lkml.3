Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459AbaDWHsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:48:07 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:63400 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbaDWHsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:48:04 -0400
Message-ID: <53577036.2040307@gmail.com>
Date: Wed, 23 Apr 2014 15:48:06 +0800
From: zhuyj <zyjzyj2000@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>, Willy Tarreau <w@1wt.eu>
CC: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        joe@perches.com, julia.lawall@lip6.fr, dingtianhong@huawei.com,
        linux-kernel@vger.kernel.org, jasowang@redhat.com, mst@redhat.com,
        "Yang, Zhangle (Eric)" <Zhangle.Yang@windriver.com>,
        "Wu, Kuaikuai" <Kuaikuai.Wu@windriver.com>,
        "Tao, Yue" <Yue.Tao@windriver.com>
Subject: Re: in kernel 2.6.x, tun/tap nic supports vlan packets
References: <534F4C1E.1000006@gmail.com> <20140417050228.GC8243@1wt.eu> <1398189237.7767.77.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1398189237.7767.77.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 01:53 AM, Ben Hutchings wrote:
> On Thu, 2014-04-17 at 07:02 +0200, Willy Tarreau wrote:
>> Hi Zhu,
>>
>> On Thu, Apr 17, 2014 at 11:35:58AM +0800, zhuyj wrote:
>>> Hi, all
>>>
>>> In kernel 2.6.x, linux depends on nic vlan hardware acceleration to
>>> insert/extract
>>> vlan tag.
Hi, Ben

Thanks for your reply.
> This is a gross overstatement.
>
> The problem I know of is that prior to Linux 2.6.37 the RX path behaved
> differently for VLAN-tagged packets depending on whether they were
> extracted by the driver/hardware.
Yes. You are right. So I backported 
0002-vlan-Centralize-handling-of-hardware-acceleration.patch to fix this 
problem.
>
> If you put a bridge (or bond) and VLAN device on top of a single
> physical device that doesn't do VLAN tag extraction, the VLAN device
> didn't get any packets because the bridge packet handler was called
> first.  Whereas, if the driver called the 'VLAN accelerated' RX path,
> the VLAN packet handler was called first.  (Linux 2.6.37 actually
> standardised on the former behaviour, and 3.2 fixed it to be the
> latter.)
Yes. So I made a patch 
"0001-tun-tap-add-the-feature-of-vlan-rx-extraction.patch" to make tap 
driver extract vlan tag.
>
> I don't know whether that's the problem zhuyj has run into.
>
> [...]
>> Well, 2.6.32.x is in deep freeze mode and it receives only critical fixes
>> once in a while. While I can appreciate that the patch above might solve
>> the issue you're facing, I'm wondering if there are not any acceptable
>> workarounds for such a deep freeze kernel. You patch is not huge,
> I think it's huge by the standards of 2.6.32.y.
>
>> but it
>> definitely affects a working driver, and I wouldn't like risking to break
>> the tap driver for other users, and I reall don't have the skills to audit
>> it completely to ensure this is not the case. And if it breaks, I'll have
>> to revert it or seek for some help on netdev.
>>
>> So I'd say that I'd rather not merge it unless I get an Acked-by from some
>> netdev people who are willing to help in case of any future regression,
>> which is unlikely but still possible.
> [...]
>
> For what it's worth, I would recommend against applying this.  I don't
> think even Red Hat has backported the VLAN changes, and they have been
> quite aggressive about backporting features to RHEL 6.
If we do not merge these patches, maybe RHEL 6 can not make tap driver 
support vlan well.

Best Regards!
Zhu Yanjun
>
> Ben.
>

