Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbaGHXnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:43:51 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:43685 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbaGHXnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:43:49 -0400
Date: Wed, 9 Jul 2014 01:43:38 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Richard Weinberger <richard@nod.at>
Cc: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hyperv: Add netpoll support
Message-ID: <20140708234338.GA4181@electric-eye.fr.zoreil.com>
References: <1404811947-5174-1-git-send-email-richard@nod.at>
 <9fb91c2ee32a4a59a2bec54043a6b9fd@BY2PR03MB299.namprd03.prod.outlook.com>
 <53BC3AC5.6000203@nod.at>
 <b2835410139848be8811403e3d7fa708@BY2PR03MB299.namprd03.prod.outlook.com>
 <53BC51B4.4010703@nod.at>
 <20140708224724.GA2994@electric-eye.fr.zoreil.com>
 <53BC7666.3050408@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BC7666.3050408@nod.at>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger <richard@nod.at> :
> Am 09.07.2014 00:47, schrieb Francois Romieu:
[...]
> > What are you taking about ? netconsole does not need to receive.
> 
> Isn't netconsole is only one user of netpoll ?

Out of tree users are irrelevant. See netpoll related comments in
cd6362befe4cc7bf589a5236d2a780af2d47bcc9

> Of course netconsole needs only to transmit SKBs.
> But if you look at other ->ndo_poll_controller implementations
> you'll notice that they care also about receiving.

It's just the long, illuminating history of netpoll :o)

Some limited Rx netpoll support may be done but it needs more work
than was originally advertised.

> > hyperv start_xmit handler almost does its own Tx completion as you have
> > noticed. The situation is imho close to a virtual device one as was veth
> > in bb446c19fefd7b4435adb12a9dd7666adc5b553a.
> 
> Bad commit reference: bb446c19fefd7b4435adb12a9dd7666adc5b553a

Sorry, it currently belongs to davem's net-next.

-- 
Ueimor
