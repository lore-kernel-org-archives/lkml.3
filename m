Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbaFPSvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:51:31 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:58525 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaFPSv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:51:29 -0400
MIME-Version: 1.0
In-Reply-To: <6B8712E6-8012-42C3-9D98-0EBD943F2894@profihost.ag>
References: <539EE86E.6030806@profihost.ag>
	<CAHA+R7OrT+x_jvDeqKgFc=ndebhB6qwecJBcT5y0ZAA+hBCJ3Q@mail.gmail.com>
	<6B8712E6-8012-42C3-9D98-0EBD943F2894@profihost.ag>
Date: Mon, 16 Jun 2014 11:51:28 -0700
Message-ID: <CAHA+R7NUKXJhaX45+OQx3ufxrWjkjnhO84cNznbijOZWru7u6w@mail.gmail.com>
Subject: Re: netconsole breaks netpoll on bridge
From: Cong Wang <cwang@twopensource.com>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        David Miller <davem@davemloft.net>,
        "bridge@lists.linux-foundation.org" 
	<bridge@lists.linux-foundation.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 11:41 AM, Stefan Priebe - Profihost AG
<s.priebe@profihost.ag> wrote:
>
>> Am 16.06.2014 um 20:05 schrieb Cong Wang <cwang@twopensource.com>:
>>
>> On Mon, Jun 16, 2014 at 5:51 AM, Stefan Priebe - Profihost AG
>> <s.priebe@profihost.ag> wrote:
>>> Hi,
>>>
>>> i'm using a vanilla 3.10.43 kernel and netconsole on top of a bridge.
>>>
>>> netconsole is used with vmbr0 (bridge) which is on top of bond0.
>>>
>>> If i want to add another bridge to vmbr0 is fails as long as netconsole
>>> is in use.
>>>
>>> # brctl addif vmbr0 fwpr2004p0
>>> can't add fwpr2004p0 to bridge vmbr0: Unknown error 524
>>>
>>> Kernel output:
>>> netpoll: (null): fwpr2004p0 doesn't support polling, aborting
>>>
>>> If i do rmmod netconsole - everything is working fine again.
>>
>> This is expected, you can't add an interface which doesn't support
>> netpoll to a bridge which is running netpoll.
>
> Thanks, so i can't use netconsole at a bridge used for vms?

You can, but you need to make sure all the devices under
this bridge support netpoll. Not considering mac learning,
bridge just broadcasts all the packets to its ports, if one of them
doesn't support netpoll, how could it work?

>
>>
>> You should stop netpoll before adding it.
>
> How to do that? What disadvantage does this have?
>

If you are using a redhat distro, run `service netconsole stop`.

Or you can disable it via configfs, check
Documentation/networking/netconsole.txt.
