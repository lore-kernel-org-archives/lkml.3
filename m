Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449AbaGHURV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 16:17:21 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932241AbaGHUQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 16:16:58 -0400
Message-ID: <53BC51B4.4010703@nod.at>
Date: Tue, 08 Jul 2014 22:16:52 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hyperv: Add netpoll support
References: <1404811947-5174-1-git-send-email-richard@nod.at> <9fb91c2ee32a4a59a2bec54043a6b9fd@BY2PR03MB299.namprd03.prod.outlook.com> <53BC3AC5.6000203@nod.at> <b2835410139848be8811403e3d7fa708@BY2PR03MB299.namprd03.prod.outlook.com>
In-Reply-To: <b2835410139848be8811403e3d7fa708@BY2PR03MB299.namprd03.prod.outlook.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 08.07.2014 22:03, schrieb KY Srinivasan:
> The VCPU the channel is bound to is available in the channel state. You could use the following code
> Fragment to ensure that the call is made on the "right" cpu:
> 
> smp_call_function_single(dev->channel->target_cpu,
>                                          netvsc_channel_cb, dev->channel, true);

This won't work as netpoll runs with IRQs disabled.
->ndo_poll_controller() has to make sure that SKBs can be received and transmitted
while IRQs are off. I thought calling the channel callback by hand would be enough
to receive SKBs.

Thanks,
//richard
