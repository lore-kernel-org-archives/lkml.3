Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab3KEUDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 15:03:46 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:44087 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754644Ab3KEUDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 15:03:44 -0500
Subject: Re: [PATCH 1/5] OF: Clear detach flag on attach
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20131105194310.GB17929@book.gsilab.sittig.org>
Date: Tue, 5 Nov 2013 22:03:34 +0200
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <033B1C12-1AD8-44E3-A9BE-C216AEBA45F2@antoniou-consulting.com>
References: <1383673816-29293-1-git-send-email-panto@antoniou-consulting.com> <1383673816-29293-2-git-send-email-panto@antoniou-consulting.com> <20131105194310.GB17929@book.gsilab.sittig.org>
To: Gerhard Sittig <gsi@denx.de>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gerhard,

On Nov 5, 2013, at 9:43 PM, Gerhard Sittig wrote:

> On Tue, Nov 05, 2013 at 19:50 +0200, Pantelis Antoniou wrote:
>> 
>> --- a/drivers/of/base.c
>> +++ b/drivers/of/base.c
>> @@ -1641,6 +1641,7 @@ int of_attach_node(struct device_node *np)
>> 	np->allnext = of_allnodes;
>> 	np->parent->child = np;
>> 	of_allnodes = np;
>> +	of_node_clear_flag(np, OF_DETACHED);
>> 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
>> 
>> 	of_add_proc_dt_entry(np);
> 
> Does this add a call to a routine which only gets introduced in a
> subsequent patch (2/5)?  If so, it would break builds during the
> series, and thus would hinder bisection.
> 

You're right, I'll re-order on the next series.

> 
> virtually yours
> Gerhard Sittig
> -- 
> DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
> HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
> Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de

Regards

-- Pantelis

