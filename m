Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab3D2RNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 13:13:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:44899 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757236Ab3D2RNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 13:13:44 -0400
Message-ID: <517EAA2D.1000407@infradead.org>
Date: Mon, 29 Apr 2013 10:13:17 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: linux-next: Tree for Apr 29 (many build errors when PROC_FS is
 not set -- part 1)
References: <20130429191754.8ee71fb814790bf345516ab8@canb.auug.org.au>
In-Reply-To: <20130429191754.8ee71fb814790bf345516ab8@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/13 02:17, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130426:
> 


Many build errors happen when CONFIG_PROC_FS is not enabled.
This is not new -- I also saw it about 2 weeks ago but did not analyze or report it.


use of PDE_DATA() (from <linux/proc_fs.h>):

drivers/net/wireless/hostap/hostap_ap.c:85:2: error: implicit declaration of function 'PDE_DATA' [-Werror=implicit-function-declaration]

fs/afs/proc.c:193:2: error: implicit declaration of function 'PDE_DATA' [-Werror=implicit-function-declaration]

drivers/block/pktcdvd.c:2598:2: error: implicit declaration of function 'PDE_DATA' [-Werror=implicit-function-declaration]

fs/ext4/super.c:1809:2: error: implicit declaration of function 'PDE_DATA' [-Werror=implicit-function-declaration]
fs/ext4/mballoc.c:2263:9: error: implicit declaration of function 'PDE_DATA' [-Werror=implicit-function-declaration]
fs/jbd2/journal.c:982:2: error: implicit declaration of function 'PDE_DATA' [-Werror=implicit-function-declaration]

net/sunrpc/cache.c:1465:9: error: implicit declaration of function 'PDE_DATA' [-Werror=implicit-function-declaration]

drivers/char/ipmi/ipmi_si_intf.c:2842:2: error: implicit declaration of function 'PDE_DATA' [-Werror=implicit-function-declaration]
drivers/gpu/drm/drm_proc.c:66:9: error: implicit declaration of function 'PDE_DATA' [-Werror=implicit-function-declaration]
net/can/proc.c:381:2: error: implicit declaration of function 'PDE_DATA' [-Werror=implicit-function-declaration]
net/can/bcm.c:229:2: error: implicit declaration of function 'PDE_DATA' [-Werror=implicit-function-declaration]


Al, would it make sense to have a stub for PDE_DATA() in
<linux/proc_fs.h> when CONFIG_PROC_FS is not enabled?



-- 
~Randy
