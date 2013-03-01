Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab3CAMCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 07:02:24 -0500
Received: from anubis.se.axis.com ([195.60.68.12]:43123 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3CAMCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 07:02:22 -0500
Date: Fri, 1 Mar 2013 13:02:18 +0100
From: Ricard Wanderlof <ricard.wanderlof@axis.com>
X-X-Sender: ricardw@lnxricardw.se.axis.com
To: Richard Genoud <richard.genoud@gmail.com>
CC: "Velykokhatko, Sergey" <Sergey.Velykokhatko@mcc-med.de>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        Brian Norris <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Bug in mtd_get_device_size()?
In-Reply-To: <CACQ1gAg0rE+X+uxRWbrPKhmdS1T0MG00cwwBbzWM+VwU4zaXmw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1303011258210.26361@lnxricardw.se.axis.com>
References: <BAF0C2081321BA469F9ADF648F97D9B04C78FA6069@MCC023.weinmann.com> <CAN8TOE9YJBvUE9GDW3krZB-Js6gUkqY23gYNLS4gFX0e2NDNZw@mail.gmail.com> <BAF0C2081321BA469F9ADF648F97D9B04C78FA6071@MCC023.weinmann.com>
 <CACQ1gAg0rE+X+uxRWbrPKhmdS1T0MG00cwwBbzWM+VwU4zaXmw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 1 Mar 2013, Richard Genoud wrote:

> From a Micron Nand datasheet :
> Micron NAND devices are specified to have a minimum of 2,008 (NVB)
> valid blocks out
> of every 2,048 total available blocks. This means the devices may have
> blocks that are
> invalid when they are shipped. An invalid block is one that contains
> one or more bad
> bits. Additional bad blocks may develop with use. However, the total
> number of avail-
> able blocks will not fall below NVB during the endurance life of the product.
>
> As there's very little information on how bad blocks appear, we can
> suppose that even on the 1st erase cycle of a block, it can turn bad.
> That's why we have to use the worst case scenario.

I would think that the primary reason for blocks to go bad is that they 
wear out so that they don't meet the endurance specifications. I.e., when 
worn out, one or more bits will start to flip significantly sooner than on 
a non-worn-out block. Wearing out is a continual process; blocks don't 
just suddenly 'go bad'.

I suppose one can imagine catastrophic failures at any time as well. I 
have never seen this case being specifically reference in an application 
note or white paper from a flash manufacturer though. As you say the 
datasheets are not very forthcoming on that issue.

/Ricard
-- 
Ricard Wolf Wanderlöf                           ricardw(at)axis.com
Axis Communications AB, Lund, Sweden            www.axis.com
Phone +46 46 272 2016                           Fax +46 46 13 61 30
