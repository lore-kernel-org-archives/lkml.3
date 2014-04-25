Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaDYIJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 04:09:44 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:33088 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbaDYIJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 04:09:32 -0400
Message-ID: <535A1840.2010109@gmail.com>
Date: Fri, 25 Apr 2014 16:09:36 +0800
From: zhuyj <zyjzyj2000@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        joe@perches.com, julia.lawall@lip6.fr, dingtianhong@huawei.com,
        linux-kernel@vger.kernel.org, jasowang@redhat.com, mst@redhat.com,
        "Yang, Zhangle (Eric)" <Zhangle.Yang@windriver.com>,
        "Wu, Kuaikuai" <Kuaikuai.Wu@windriver.com>,
        "Tao, Yue" <Yue.Tao@windriver.com>
Subject: Re: in kernel 2.6.x, tun/tap nic supports vlan packets
References: <534F4C1E.1000006@gmail.com> <20140417050228.GC8243@1wt.eu> <1398189237.7767.77.camel@deadeye.wl.decadent.org.uk> <53577036.2040307@gmail.com> <1398253309.7767.136.camel@deadeye.wl.decadent.org.uk> <53587280.4020101@gmail.com> <20140424052447.GC17409@1wt.eu>
In-Reply-To: <20140424052447.GC17409@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 01:24 PM, Willy Tarreau wrote:
> On Thu, Apr 24, 2014 at 10:10:08AM +0800, zhuyj wrote:
>> On 04/23/2014 07:41 PM, Ben Hutchings wrote:
>>> On Wed, 2014-04-23 at 15:48 +0800, zhuyj wrote:
>>>> On 04/23/2014 01:53 AM, Ben Hutchings wrote:
>>> [...]
>>>>> For what it's worth, I would recommend against applying this.  I don't
>>>>> think even Red Hat has backported the VLAN changes, and they have been
>>>>> quite aggressive about backporting features to RHEL 6.
>>>> If we do not merge these patches, maybe RHEL 6 can not make tap driver
>>>> support vlan well.
>>> RHEL 6 isn't based on 2.6.32.y, they do all their own backporting.
>> Hi, Ben
>>
>> It is well known that extraction vlan tag is not implemented in kernel
>> 2.6.32.y.  Kernel 2.6.32.y depends on nic hardware to extract vlan tag.
>> So if the patches are not applied, tap driver can not support vlan well.
> What Ben is saying is that RHEL doesn't use 2.6.32.y, but did their own
> fork of 2.6.32 so even if we merged your patch, they wouldn't pick it
> from this tree anyway. However they could possibly take your patch if
> some customers requested the feature even if it's not in 2.6.32.y.
OK. as your wish.

Best Regards!
Zhu Yanjun
>
> Clearly, the fact that nobody complained about this in 4.5 years of
> 2.6.32 means that there's no particular reason any user would suddenly
> miss it now. 2.6.32.y is mostly used to update existing deployments but
> rarely for new deployments. That's why the usefulness of your backport
> in this kernel for its users is likely limited, and at the same time
> the risk of causing a regression is far from being null for existing
> users (eg: if some worked around the issue a different way, their
> workaround would likely not work anymore).
>
> Best regards,
> Willy
>
>

