Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaFWFsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 01:48:18 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52776 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaFWFsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 01:48:17 -0400
Date: Mon, 23 Jun 2014 07:48:14 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: plug false-positive warning in get_prompt_str()
 seen with gcc-4.9
Message-ID: <20140623054813.GG13440@pengutronix.de>
References: <20140525164751.28577.74072.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140525164751.28577.74072.stgit@zurg>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, May 25, 2014 at 08:47:51PM +0400, Konstantin Khlebnikov wrote:
> scripts/kconfig/menu.c: In function ‘get_symbol_str’:
> scripts/kconfig/menu.c:590:18: warning: ‘jump’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>      jump->offset = strlen(r->s);
>                   ^
> scripts/kconfig/menu.c:551:19: note: ‘jump’ was declared here
>   struct jump_key *jump;
>                    ^

I'm seeing that problem with a 4.8.2 toolchain on next-20140623 with
ARCH=arm, too.

Maybe better use uninitialized_var? And point out the commit that
introduced the issue please.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
