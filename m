Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788Ab3EORW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 13:22:28 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39224 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759753Ab3EORW1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 13:22:27 -0400
MIME-Version: 1.0
Message-ID: <76ac8597-9be3-44fd-a3d5-39c6130a171a@default>
Date: Wed, 15 May 2013 10:22:11 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>, bob.liu@oracle.com,
        dan.magenheimer@oracle.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        xen-devel@lists.xensource.com
Subject: RE: [PATCH] Fixes, cleanups, compile warning fixes, and documentation
 update for Xen tmem driver (v2).
References: <<1368554966-30469-1-git-send-email-konrad.wilk@oracle.com>>
In-Reply-To: <<1368554966-30469-1-git-send-email-konrad.wilk@oracle.com>>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6668.5000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Konrad Rzeszutek [mailto:ketuzsezr@gmail.com] On Behalf Of Konrad Rzeszutek Wilk
> Sent: Tuesday, May 14, 2013 12:09 PM
> To: bob.liu@oracle.com; dan.magenheimer@oracle.com; linux-kernel@vger.kernel.org; akpm@linux-
> foundation.org; linux-mm@kvack.org; xen-devel@lists.xensource.com
> Subject: [PATCH] Fixes, cleanups, compile warning fixes, and documentation update for Xen tmem driver
> (v2).
> 
> Heya,
> 
> These nine patches fix the tmem driver to:
>  - not emit a compile warning anymore (reported by 0 day test compile tool)
>  - remove the various nofrontswap, nocleancache, noselfshrinking, noselfballooning,
>    selfballooning, selfshrinking bootup options.
>  - said options are now folded in the tmem driver as module options and are
>    much shorter (and also there are only four of them now).
>  - add documentation to explain these parameters in kernel-parameters.txt
>  - And lastly add some logic to not enable selfshrinking and selfballooning
>    if frontswap functionality is off.
> 
> That is it. Tested and ready to go. If nobody objects will put on my queue
> for Linus on Monday.

FWIW, I've scanned all of these and they look sane and good.  So consider all:

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
 
>  Documentation/kernel-parameters.txt |   21 ++++++++
>  drivers/xen/Kconfig                 |    7 +--
>  drivers/xen/tmem.c                  |   87 ++++++++++++++++-------------------
>  drivers/xen/xen-selfballoon.c       |   47 ++----------------
>  4 files changed, 69 insertions(+), 93 deletions(-)
> 
> (oh nice, more deletions!)
> 
> Konrad Rzeszutek Wilk (9):
>       xen/tmem: Cleanup. Remove the parts that say temporary.
>       xen/tmem: Move all of the boot and module parameters to the top of the file.
>       xen/tmem: Split out the different module/boot options.
>       xen/tmem: Fix compile warning.
>       xen/tmem: s/disable_// and change the logic.
>       xen/tmem: Remove the boot options and fold them in the tmem.X parameters.
>       xen/tmem: Remove the usage of 'noselfshrink' and use 'tmem.selfshrink' bool instead.
>       xen/tmem: Remove the usage of '[no|]selfballoon' and use 'tmem.selfballooning' bool instead.
>       xen/tmem: Don't use self[ballooning|shrinking] if frontswap is off.
