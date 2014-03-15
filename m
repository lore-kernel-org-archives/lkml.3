Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbaCOU0S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 16:26:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51747 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633AbaCOU0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 16:26:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH] zram: include linux/err.h
Date: Sat, 15 Mar 2014 21:26:02 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <201403151040.09139.arnd@arndb.de> <20140315141839.GA361@swordfish>
In-Reply-To: <20140315141839.GA361@swordfish>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201403152126.02967.arnd@arndb.de>
X-Provags-ID: V02:K0:Gi/12FgDba88RfDrnT80dso4kJf/8arwUJrkokiostB
 XTyELpzgGXabWhENMOq8r4ylIvXy/Iw8VAXS3PUUPXTXuP/ya0
 vpcGNhCCg2Ms6A/RMvXb0M04XVazp0CIFxGyEzHmS9kiS1NSny
 VQja2auNCNJTkSeGFYseJ1VGJYfIWT5Uw4jiA6icSoMnv0wKCI
 RTgFRyN/wS4CdUoHLDamxI36GxE2EgEu/XxA3b0pxh1hSXyWfK
 FBGXF+GQn9WCpjEeKcIma6+i/0cMP4rJJSJaoisI7YyY+7Kw89
 2cdlGoOWqnertgGIAqUSDBmCKNPjClW8PzAlBQnzAKdmZHEnyB
 iJpj6k4aTVygOeHB1QXdjmch/02kVDKUzPZVItJvC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 March 2014, Sergey Senozhatsky wrote:
> On (03/15/14 10:40), Arnd Bergmann wrote:
> > The zram driver uses the ERR_PTR macro defined in <linux/err.h>
> > and relies on this header to be included implicitly through
> > other headers, which is not (always) the case on the ARM architecture.
> > 
> 
> returned from zcomp ERR_PTR is checked and used in zram_drv.c, should
> in this case there also be inclusion of err.h in zram_drv.h? if so, it
> probably makes sense to move inclusion of err.h to zcomp.h, which is
> included both in zcomp.c and zram_drv.c
> 

The normal convention is to only include headers from other headers if
that is required by the contents of the header itself.

Following the common conventions, it's better to include linux/err.h
in both zram_drv.c and zcomp.c, but not in zram_drv.h.
I didn't do that in my patch, because I only got a build error in
one of the two files.

	Arnd
