Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab3JXShP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 14:37:15 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40916 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab3JXShN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 14:37:13 -0400
Date: Thu, 24 Oct 2013 11:37:08 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Wan ZongShun <mcuos.com@gmail.com>,
        Andrey Moiseev <o2g.org.ru@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Josh Wu <josh.wu@atmel.com>,
        Ferruh Yigit <fery@cypress.com>, Pau Oliva Fora <pof@eslack.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-input@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 4/8] input: Remove OOM message after input_allocate_device
Message-ID: <20131024183707.GA5281@core.coreip.homeip.net>
References: <cover.1382555436.git.joe@perches.com>
 <cc5e6a317bc9ef33cfdfae3ed9d3a47b5319a47b.1382555436.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc5e6a317bc9ef33cfdfae3ed9d3a47b5319a47b.1382555436.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Wed, Oct 23, 2013 at 12:14:50PM -0700, Joe Perches wrote:
> Emitting an OOM message isn't necessary after input_allocate_device
> as there's a generic OOM and a dump_stack already done.

No, please don't. The kzalloc may get changed in the future to not dump
stack (that was added originally because not everyone was handling OOM
properly, right?), input core might get changed to use something else
than kzalloc, etc, etc.

The majority of errors use dev_err so we also get idea what device
failed (if there are several), and more.

Thanks.

-- 
Dmitry
