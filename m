Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbaGHXIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:08:39 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625AbaGHXIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:08:38 -0400
Message-ID: <53BC79F3.8080409@nod.at>
Date: Wed, 09 Jul 2014 01:08:35 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hyperv: Add netpoll support
References: <1404811947-5174-1-git-send-email-richard@nod.at> <9fb91c2ee32a4a59a2bec54043a6b9fd@BY2PR03MB299.namprd03.prod.outlook.com> <53BC3AC5.6000203@nod.at> <b2835410139848be8811403e3d7fa708@BY2PR03MB299.namprd03.prod.outlook.com> <53BC51B4.4010703@nod.at> <20140708224724.GA2994@electric-eye.fr.zoreil.com>
In-Reply-To: <20140708224724.GA2994@electric-eye.fr.zoreil.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.07.2014 00:47, schrieb Francois Romieu:
> Richard Weinberger <richard@nod.at> :
> [...]
>> This won't work as netpoll runs with IRQs disabled.
>> ->ndo_poll_controller() has to make sure that SKBs can be received and transmitted
>> while IRQs are off. I thought calling the channel callback by hand would be
>> enough to receive SKBs.
> 
> What are you taking about ? netconsole does not need to receive.
> 
> hyperv start_xmit handler almost does its own Tx completion as you have
> noticed. The situation is imho close to a virtual device one as was veth
> in bb446c19fefd7b4435adb12a9dd7666adc5b553a.

Ah, net-next.git.
My first (in-house) patch had the same empty poll controller as tun.c and now veth.c have.
If we are fine with tx only, I'll happily resend an updated patch with an empty poll controller. :-)

Thanks,
//richard
