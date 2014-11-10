Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaKJR7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:59:12 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:49605 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaKJR7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:59:09 -0500
X-Originating-IP: 50.43.41.112
Date: Mon, 10 Nov 2014 09:58:57 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marian Chereji <marian.chereji@freescale.com>,
        Catalina Mocanu <catalina.mocanu@gmail.com>
Subject: Re: linux-next: manual merge of the akpm-current tree with the tiny
 tree
Message-ID: <20141110175856.GD18766@thin>
References: <20141110195912.324b90ed@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110195912.324b90ed@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 07:59:12PM +1100, Stephen Rothwell wrote:
> Hi Andrew,
> 
> Today's linux-next merge of the akpm-current tree got a conflict in
> lib/Kconfig between commit 3a8aeefbd4e9 ("lib: halfmd4: Make halfmd4.c
> optional") from the tiny tree and commit c7f379b518a3 ("lib: Add CRC64
> ECMA module") from the akpm-current tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good.

- Josh Triplett

> diff --cc lib/Kconfig
> index b8c97f05140d,2faf7b2de5b3..000000000000
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@@ -186,9 -180,13 +186,16 @@@ config CRC
>   	  when they need to do cyclic redundancy check according CRC8
>   	  algorithm. Module will be called crc8.
>   
> + config CRC64_ECMA
> + 	tristate "CRC64 ECMA function"
> + 	help
> + 	  This option provides CRC64 ECMA function. Drivers may select this
> + 	  when they need to do cyclic redundancy check according to the CRC64
> + 	  ECMA algorithm.
> + 
>  +config HALFMD4
>  +	bool
>  +
>   config AUDIT_GENERIC
>   	bool
>   	depends on AUDIT && !AUDIT_ARCH


