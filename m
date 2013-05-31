Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab3EaPaC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:30:02 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60989 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab3EaP3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:29:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Timur Tabi <timur@tabi.org>
Cc: monstr@monstr.eu, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v3 7/8] video: xilinxfb: Fix sparse warnings
Date: Fri, 31 May 2013 17:29:50 +0200
Message-ID: <4930944.aMQtpv2nTI@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <51A8BC83.6050809@tabi.org>
References: <cover.1370004925.git.michal.simek@xilinx.com> <1466524.sgAzczhnBg@wuerfel> <51A8BC83.6050809@tabi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ttLR6eW7bzmQm1ISMDSQNghsQ23SNtmIzFIQgycEkjH
 jz6g2Sunyv9195lYV5OEoRkIM8VCP38Xyp9hhuOE14TpPyo6wA
 E9gRVbW/xtK23MV2oaccmKrdwdK9JwkI08a+9QVYQjw7/ZrL6I
 PYavPivQSBFjqvUZlf+Xe/pwsp7onDrdAfPTS0o5rDmxavFS5q
 IDAX/5KgGqoGIqAwyWn+zuiT9ZlZ5W6TljpBvRT6cJhO0o8zzH
 k9FInzc1qhkBM92kQJtDVjpYnmDHfYzZ06uD3Yp3JBsMZJpZcC
 81OvLWkUUoEQRblCqUswCrSqDl9fNoAlvLXE4wtjwQAz/+qJGR
 TDvepQX5HrxvXzFGt+Rs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 May 2013 10:06:43 Timur Tabi wrote:
> On 05/31/2013 09:56 AM, Arnd Bergmann wrote:
> > Yes, unfortunately, this is what all other frame buffer drivers do
> > at the moment. It is technically not correct, but most architectures
> > are able to call readl/writel on regular memory, or dereference
> > __iomem tokens, so we often get away with it. It's probably not
> > worth fixing it in the fbdev code base as that would be a huge
> > change, and people are migrating to DRM/KMS.
> 
> But why bother fixing this bug if it just makes things worse?  Sparse is
> supposed to warn us about bad code.  This patch doesn't fix the bug, it
> just masks the warnings!

Yes, good point. It's probably best cast the ioremap() output to
a regular pointer here, as that is actually just uncached RAM,
not an MMIO register.

	Arnd
