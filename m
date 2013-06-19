Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab3FSQQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 12:16:14 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:28688 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218Ab3FSQQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 12:16:12 -0400
Message-ID: <1371658566.1956.35.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH 1/1] drivers/net: param for lapbether for specific
 ethernet device
From: Ben Hutchings <bhutchings@solarflare.com>
To: Stephen Moorby <steve.moorby@ntlworld.com>
CC: <davem@davemloft.net>, <jiri@resnulli.us>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Wed, 19 Jun 2013 17:16:06 +0100
In-Reply-To: <51C16A07.3070903@ntlworld.com>
References: <51C16A07.3070903@ntlworld.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19954.000
X-TM-AS-Result: No--13.521200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-19 at 09:21 +0100, Stephen Moorby wrote:
>  From 35607dd0607bca5322860703143c31cb04377764 Mon Sep 17 00:00:00 2001
> From: Stephen Moorby <steve.moorby@ntlworld.com>
> Date: Wed, 19 Jun 2013 08:22:51 +0100
> Subject: [PATCH 1/1] drivers/net: param for lapbether for specific ethernet
>   device
> 
> The lapbether driver binds to the first ethernet device that comes up.
> This causes problems in hardware with multiple ethernet interfaces,
> potentially resulting in the LAPB traffic on the wrong interface.
> Have added a module parameter 'eth_dev' to specify the ethernet
> interface over which lapbether should operate.  The module behaves
> as before if no device is specified.
[...]

The proper interface for creating and destroying layered devices is
rtnetlink.

The current behaviour is weird and it seems like it would be hard for
userland to reliably get the LAPB interface(s) into the right state.  So
maybe the auto-creation should be removed, or, for backward
compatibility (and at the risk of annoying David) it should be possible
to disable it by setting a module parameter.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

