Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbaGUGzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 02:55:16 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65276 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbaGUGzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 02:55:13 -0400
Message-ID: <53CCB944.8090709@nod.at>
Date: Mon, 21 Jul 2014 08:55:00 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Yue Zhang (OSTC DEV)" <yuezha@microsoft.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>, Thomas Shao <huishao@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>
Subject: Re: [PATCH] Hyperv: Trigger DHCP renew after host hibernation
References: <1405680903-28176-1-git-send-email-yuezha@microsoft.com> <CAFLxGvxQU_z+mChHsNSu9VZEdXrU+RU75k6H18uKbdAj2TKD5g@mail.gmail.com> <DC7803B42427924284F2D5252E076A3B44769DCA@SINEX14MBXC416.southpacific.corp.microsoft.com>
In-Reply-To: <DC7803B42427924284F2D5252E076A3B44769DCA@SINEX14MBXC416.southpacific.corp.microsoft.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yie,

Am 21.07.2014 04:44, schrieb Yue Zhang (OSTC DEV):
>> From: Richard Weinberger [mailto:richard.weinberger@gmail.com]
>> Why 10? Is this a random number which works by accident for ifplugd?
>> What about other networking implementations, is 10 also ok for them?
>> --
>> Thanks,
>> //richard
> 
> Hi, Richard
> 
> I checked ifplugd's code. The deferring time is 5 seconds. That's how  comes 
> the "10s". I agree with you this is a magic number and should be avoid. However, 
> this is the only feasible solution right now. If there is a better solution, I will be 
> glad to switch to it.
> 
> I tested the fix in Redhat, Ubuntu and SUSE and it works in all of them.

The problem I see is that there is no good way to trigger a DHCP renew from
a network device drivers. You're on the wrong layer.
10 seconds may work but this is IMHO a hack which can easily break.
There are also more networking implementations than ifplugd.
Specially the systemd implementation looks promising.

Can't you propagate the RNDIS_STATUS_NETWORK_CHANGE event to userspace?
IIRC on HyperV guests already have a guest daemon. Let the daemon handle
the event such that distros can install their own hooks...

Thanks,
//richard
