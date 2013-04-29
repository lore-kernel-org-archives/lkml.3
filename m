Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241Ab3D2Rma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 13:42:30 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37764 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757857Ab3D2Rm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 13:42:27 -0400
Date: Mon, 29 Apr 2013 19:42:21 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Benjamin Poirier <bpoirier@suse.de>
Subject: Re: linux-next: Tree for Apr 29 (kconfig)
Message-ID: <20130429174221.GB3989@free.fr>
References: <20130429191754.8ee71fb814790bf345516ab8@canb.auug.org.au>
 <517E9F12.1020309@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517E9F12.1020309@infradead.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy, All,

On Mon, Apr 29, 2013 at 09:25:54AM -0700, Randy Dunlap wrote:
> make ARCH=x86_64 O=X64 xconfig &
>   GEN     /local/lnx/next/linux-next-20130429/X64/Makefile
>   HOSTCXX scripts/kconfig/qconf.o
> In file included from scripts/kconfig/expr.h:15:0,
>                  from scripts/kconfig/lkc.h:9,
>                  from scripts/kconfig/qconf.cc:46:
> scripts/kconfig/list.h: In function 'void list_del(list_head*)':
> scripts/kconfig/list.h:128:16: error: invalid conversion from 'void*' to 'list_head*' [-fpermissive]
> scripts/kconfig/list.h:129:16: error: invalid conversion from 'void*' to 'list_head*' [-fpermissive]
> make[2]: *** [scripts/kconfig/qconf.o] Error 1

Found the culprit:

9a69abf80edf2ea0dac058cab156879d29362788 is the first bad commit
commit 9a69abf80edf2ea0dac058cab156879d29362788
Author: Benjamin Poirier <bpoirier@suse.de>
Date:   Tue Apr 16 10:07:23 2013 -0400

    menuconfig: Add "breadcrumbs" navigation aid

    Displays a trail of the menu entries used to get to the current menu.

    Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
    Tested-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
    [yann.morin.1998@free.fr: small, trivial code re-ordering]
    Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>

I'll submit a fix in a moment.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
