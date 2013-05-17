Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab3EQJ5x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 05:57:53 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:54261 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab3EQJ5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 05:57:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/7] media: davinci: vpif: remove unwanted header includes
Date: Fri, 17 May 2013 11:58:08 +0200
Message-ID: <14563937.EKN96hEmBk@avalon>
User-Agent: KMail/4.10.2 (Linux/3.7.10-gentoo-r1; KDE/4.10.2; x86_64; ; )
In-Reply-To: <CA+V-a8sCk2STGuEJnyp99yA218UzZFXp0aXAdQOVkZzZmG8msg@mail.gmail.com>
References: <1368709102-2854-1-git-send-email-prabhakar.csengg@gmail.com> <1561290.MnyCnpJz5W@avalon> <CA+V-a8sCk2STGuEJnyp99yA218UzZFXp0aXAdQOVkZzZmG8msg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

On Friday 17 May 2013 10:40:24 Prabhakar Lad wrote:
> On Thu, May 16, 2013 at 6:32 PM, Laurent Pinchart wrote:
> > On Thursday 16 May 2013 18:28:16 Lad Prabhakar wrote:
> >> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> >> 
> >> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> >> ---
> >> 
> >>  drivers/media/platform/davinci/vpif.c |    7 -------
> >>  1 files changed, 0 insertions(+), 7 deletions(-)
> >> 
> >> diff --git a/drivers/media/platform/davinci/vpif.c
> >> b/drivers/media/platform/davinci/vpif.c index ea82a8b..d354d50 100644
> >> --- a/drivers/media/platform/davinci/vpif.c
> >> +++ b/drivers/media/platform/davinci/vpif.c
> >> @@ -17,18 +17,11 @@
> >>   * GNU General Public License for more details.
> >>   */
> >> 
> >> -#include <linux/init.h>
> >>  #include <linux/module.h>
> >>  #include <linux/platform_device.h>
> >> -#include <linux/spinlock.h>
> >> -#include <linux/kernel.h>
> >> -#include <linux/io.h>
> >> -#include <linux/err.h>
> >>  #include <linux/pm_runtime.h>
> >>  #include <linux/v4l2-dv-timings.h>
> > 
> > I think you should keep most of those includes. For instance this file
> > uses spinlock functions, so linux/spinlock.h should be included. It might
> > work fine now due to nested includes, but if someone reorganizes the
> > kernel headers internal includes then the driver might break. As a general
> > rule of good practice you should include headers for all the APIs you use.
> 
> OK, do you want me too drop the similar patches from this series ?

Please at least go through them and make sure to keep the includes for APIs 
used in the file. If there's unneeded includes you can of course remove them, 
and if it turns out that all includes are useful please drop the patch.

-- 
Regards,

Laurent Pinchart

