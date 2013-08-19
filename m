Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab3HSKUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 06:20:30 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38692 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab3HSKU0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 06:20:26 -0400
X-AuditID: cbfec7f5-b7f5f6d00000105f-5e-5211f168af41
From: Tomasz Figa <t.figa@samsung.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>, kgene.kim@samsung.com,
        Dan Williams <djbw@fb.com>, linus.walleij@linaro.org,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v2 2/4] dmaengine: add driver for Samsung s3c24xx SoCs
Date: Mon, 19 Aug 2013 12:20:23 +0200
Message-id: <2108924.tnr1vBaclB@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.1-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <20130819044811.GR32147@intel.com>
References: <201308141359.13872.heiko@sntech.de>
 <201308141400.25681.heiko@sntech.de> <20130819044811.GR32147@intel.com>
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=iso-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t/xK7oZHwWDDDYeYLPY3P+AzeL/o9es
	Fr0LrrJZTPmznMni8q45bBYzzu9jspj3eSeTxapdfxgtXvbtZ3Hg9JjY/I7dY+esu+wei/e8
	ZPK4c20Pm0ffllWMHtuvzWP2+LxJLoA9issmJTUnsyy1SN8ugSvjy5vPLAXvOCreHr7N2sDY
	yN7FyMkhIWAisaz3DiOELSZx4d56ti5GLg4hgaWMEmv6D7FDOF1MEtNmzGQDqWITUJP43PAI
	zBYRUJXY8rODEaSIWWAJk8TDufOBHA4OYQEviSfnOEBMFqCa57+dQcp5BTQlNr+7ygRi8wuo
	S7zb9hTMFhVwkXixYynYSE4BfYkrTaeZQWwhgSqJC11PWSB6BSV+TL4HZjMLaEs8eXeBFcLW
	kej9/o15AqPgLCRls5CUzUJStoCReRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGSJR83cG4
	9JjVIUYBDkYlHl4LN8EgIdbEsuLK3EOMEhzMSiK8LGpAId6UxMqq1KL8+KLSnNTiQ4xMHJxS
	DYzHix+JSMRmr41aenJJSOP8Iu2KDyltUziTImLXvFDp0/n2N+z+iQavouSvJyV0YqTu9f5b
	xtuUq/dgxpO73qdvdAnF/1FZvMzK7vD75n1PbIpkJ6212f5/1tNrhnF8m1aesxJnzVacu26n
	6663XatW7HbXqu5jT07kcQjMK+I0zq2d9XPB2o9KLMUZiYZazEXFiQBzYS91cAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 of August 2013 10:18:12 Vinod Koul wrote:
> On Wed, Aug 14, 2013 at 02:00:25PM +0200, Heiko Stübner wrote:
> > This adds a new driver to support the s3c24xx dma using the dmaengine
> > and makes the old one in mach-s3c24xx obsolete in the long run.
> > 
> > Conceptually the s3c24xx-dma feels like a distant relative of the pl08x
> > with numerous virtual channels being mapped to a lot less physical
> > ones.
> > The driver therefore borrows a lot from the amba-pl08x driver in this
> > regard. Functionality-wise the driver gains a memcpy ability in
> > addition
> > to the slave_sg one.
> 
> If that is the case why cant we have this driver supported from pl08x
> driver? If the delta is only mapping then can that be seprated or both
> mapping hanlded? Maybe you and Linus have already though about that?

Well, the similarity here is only conceptual. Both controllers are 
completely different in terms of their programming interfaces, not even 
mentioning that s3c24xx-dma doesn't support LLIs and this must be handled 
in software.

Best regards,
Tomasz

