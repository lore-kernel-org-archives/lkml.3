Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab3KFItz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 03:49:55 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:33965 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756166Ab3KFItw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 03:49:52 -0500
Subject: Re: [PATCH 1/5] OF: Clear detach flag on attach
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <527A01C9.2090306@nsn.com>
Date: Wed, 6 Nov 2013 10:49:44 +0200
Cc: Gerhard Sittig <gsi@denx.de>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <99B265B8-F5D0-4138-BA1E-0F09C95A60F4@antoniou-consulting.com>
References: <1383673816-29293-1-git-send-email-panto@antoniou-consulting.com> <1383673816-29293-2-git-send-email-panto@antoniou-consulting.com> <20131105194310.GB17929@book.gsilab.sittig.org> <033B1C12-1AD8-44E3-A9BE-C216AEBA45F2@antoniou-consulting.com> <527A01C9.2090306@nsn.com>
To: Alexander Sverdlin <alexander.sverdlin@nsn.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

I'm not exactly sure, but I think it is still needed.
Since at that point the tree is attached.

Grant?

Regards

-- Pantelis

On Nov 6, 2013, at 10:46 AM, Alexander Sverdlin wrote:

> Hello Pantelis,
> 
> On 05/11/13 21:03, ext Pantelis Antoniou wrote:
>> On Nov 5, 2013, at 9:43 PM, Gerhard Sittig wrote:
>>>> --- a/drivers/of/base.c
>>>> +++ b/drivers/of/base.c
>>>> @@ -1641,6 +1641,7 @@ int of_attach_node(struct device_node *np)
>>>> 	np->allnext = of_allnodes;
>>>> 	np->parent->child = np;
>>>> 	of_allnodes = np;
>>>> +	of_node_clear_flag(np, OF_DETACHED);
>>>> 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
>>>> 
>>>> 	of_add_proc_dt_entry(np);
>>> 
>>> Does this add a call to a routine which only gets introduced in a
>>> subsequent patch (2/5)?  If so, it would break builds during the
>>> series, and thus would hinder bisection.
>>> 
>> 
>> You're right, I'll re-order on the next series.
> 
> Is it necessary at all now, after these fixes:
> 9e401275 of: fdt: fix memory initialization for expanded DT
> 0640332e of: Fix missing memory initialization on FDT unflattening
> 92d31610 of/fdt: Remove duplicate memory clearing on FDT unflattening
> 
> ?
> 
> -- 
> Best regards,
> Alexander Sverdlin.

