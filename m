Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbaEEUkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:40:19 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46088 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbaEEUkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:40:17 -0400
Date: Mon, 5 May 2014 13:40:22 -0700
From: Olof Johansson <olof@lixom.net>
To: Boris BREZILLON <brezillonboris@gmail.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: Re: [PATCH] net: macb: set interface name based on DT aliases
Message-ID: <20140505204022.GA27961@quad.lixom.net>
References: <1394620196-6295-1-git-send-email-b.brezillon.dev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394620196-6295-1-git-send-email-b.brezillon.dev@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 11:29:56AM +0100, Boris BREZILLON wrote:
> Use aliases to set the interface name (ethX) instead of automatic
> assignement.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
> ---
> 
> Hello Nicolas, Jean-Christophe,
> 
> This is an example on how we could set the ethernet interface id based on DT
> aliases.
> As you can see this patch is not properly separated.
> 
> I'm still not happy with this approach for several reasons:
> 1) If another ethernet iface has already been registered with the same id the
>    net dev registration will fail.
> 2) We bypass the ethernet macros/functions and directly use the net device
>    functions which IMHO is not future proof.

[Sorry for the late reply, going through old backlog of unread email]

Looks like this should live in networking core instead of in the driver, it's
how we handle it in other subsystems.

I don't know what DaveM's opinions on that is though.


-Olof

