Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab3JBOld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:41:33 -0400
Received: from b232-35.smtp-out.amazonses.com ([199.127.232.35]:12375 "EHLO
	b232-35.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753480Ab3JBOlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:41:31 -0400
Date: Wed, 2 Oct 2013 14:41:29 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Frank Rowand <frowand.list@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, Linux Kernel list <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Bobniev, Roman" <Roman.Bobniev@sonymobile.com>,
        "Bird, Tim" <Tim.Bird@sonymobile.com>,
        =?ISO-8859-15?Q?=22Andersson=2C_Bj=F6rn=22?= 
	<Bjorn.Andersson@sonymobile.com>
Subject: Re: [PATCH] slub: Proper kmemleak tracking if CONFIG_SLUB_DEBUG
 disabled
In-Reply-To: <5245ECC3.8070200@gmail.com>
Message-ID: <00000141799dd4b3-f6df96c0-1003-427d-9bd8-f6455622f4ea-000000@email.amazonses.com>
References: <5245ECC3.8070200@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.127.232.35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Sep 2013, Frank Rowand wrote:

> Move the kmemleak code for small block allocation out from
> under CONFIG_SLUB_DEBUG.

Well in that case it may be better to move the hooks as a whole out of
the CONFIG_SLUB_DEBUG section. Do the #ifdeffering for each call from the
hooks instead.

The point of the hook functions is to separate the hooks out of the
functions so taht they do not accumulate in the main code.

The patch moves one hook back into the main code. Please keep the checks
in the hooks.
