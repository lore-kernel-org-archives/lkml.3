Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab3JBQYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:24:55 -0400
Received: from b232-35.smtp-out.amazonses.com ([199.127.232.35]:2492 "EHLO
	b232-35.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753046Ab3JBQYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:24:55 -0400
Date: Wed, 2 Oct 2013 16:24:53 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Catalin Marinas <catalin.marinas@arm.com>
cc: "Bird, Tim" <Tim.Bird@sonymobile.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "Bobniev, Roman" <Roman.Bobniev@sonymobile.com>,
        =?ISO-8859-15?Q?Andersson=2C_Bj=F6rn?= 
	<Bjorn.Andersson@sonymobile.com>
Subject: Re: [PATCH] slub: Proper kmemleak tracking if CONFIG_SLUB_DEBUG
 disabled
In-Reply-To: <20131002155417.GB29794@arm.com>
Message-ID: <0000014179fc82ac-8e47c69d-8c5a-4f75-957d-15741eb36eda-000000@email.amazonses.com>
References: <5245ECC3.8070200@gmail.com> <00000141799dd4b3-f6df96c0-1003-427d-9bd8-f6455622f4ea-000000@email.amazonses.com> <F5184659D418E34EA12B1903EE5EF5FD8538E86615@seldmbx02.corpusers.net> <20131002155417.GB29794@arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.127.232.35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Oct 2013, Catalin Marinas wrote:

> Kmemleak doesn't depend on SLUB_DEBUG (at least it didn't originally ;),
> so I don't think we should add an artificial dependency (or select). Can
> we have kmemleak_*() calls in both debug and !debug hooks?

Yes if you move the hook calls out from under CONFIG_SLUB_DEBUG.

