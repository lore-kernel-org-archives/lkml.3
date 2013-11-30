Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616Ab3K3BrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 20:47:21 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:15294 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab3K3BrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 20:47:17 -0500
Message-ID: <52994393.8060601@huawei.com>
Date: Sat, 30 Nov 2013 09:46:59 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Serge Hallyn <serge.hallyn@ubuntu.com>
CC: <containers@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>, <dingtianhong@huawei.com>
Subject: Re: Q: use vlan in container
References: <5296E003.80804@huawei.com> <20131129050549.GB8830@sergelap> <529836CD.1080900@huawei.com> <20131129141826.GA5018@sergelap>
In-Reply-To: <20131129141826.GA5018@sergelap>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/11/29 22:18, Serge Hallyn wrote:
> Quoting Libo Chen (clbchenlibo.chen@huawei.com):
>> On 2013/11/29 13:05, Serge Hallyn wrote:
>>> Quoting Libo Chen (clbchenlibo.chen@huawei.com):
>>>> Hello LXC experts,
>>>>
>>>> 	I meet a problem. When using vlan as network device in suse11 system container,
>>>> I can not use halt to stop this container. It hung on "eth0 is still used from interfaces eth0" in cycle.
>>>>
>>>> The config file:
>>>>
>>>> lxc.network.type = vlan
>>>> lxc.network.flags = up
>>>> lxc.network.link = eth0
>>>> lxc.network.name = eth0
>>>> lxc.network.vlan.id = 1301
>>>> lxc.network.ipv4 = 128.5.131.100/24
>>>>
>>>>
>>>> The reason is in the shell command /sbin/ifdown, see below:
>>>>
>>>> ######################################################################
>>>> # Shut down depending interfaces
>>>> #
>>>> # Check if there are interfaces which depend on this interface. If yes these
>>>> # have to be shut down first.
>>>> # For example these might be bonding or vlan interfaces. Note that we don't
>>>> # catch all types of depending interfaces currently. See function
>>>> # 'get_depending_ifaces' in file 'functions' for details.
>>>> #
>>>> test "$SCRIPTNAME" = ifdown && DEP_IFACES=`get_depending_ifaces $INTERFACE`
>>>> if [ "$?" = 0 -a "$NODEPS" != yes ] ; then
>>>>         message "`printf "    %-9s is still used from interfaces %s" \
>>>>                          $INTERFACE "$DEP_IFACES"`"
>>>>         for DI in $DEP_IFACES; do
>>>
>>> Should the proper fix be to fix this script so that it doesn't call
>>> ifdown recursively if $DI = $INTERFACE ?
>>
>> Hi Serge,
>>
>> yes, I had try this way before as below:
>>
>>         for DI in $DEP_IFACES; do
>> 	         if [ "$DI" != "$INTERFACE" ] ; then
>>                        ifdown $DI -o $OPTIONS
>> 	         fi
>>         done
>>
>> It works well, but I have no idea it is safe enough and no side effects?
> 
> It's safe enough and should have no side effects itself.  But
> I recommend you first look up how get_depending_ifaces() is
> implemented.  That's where this really should be fixed, and if
> it turns out that the proper fix for *that* is in the kernel
> then that's ok.

thank you for your suggestion.

Libo


> 
> -serge
> 
> .
> 


