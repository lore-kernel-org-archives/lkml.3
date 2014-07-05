Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbaGET00 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 15:26:26 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29329 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136AbaGET0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 15:26:24 -0400
Date: Sat, 5 Jul 2014 22:23:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Rickard Strandqvist <rickard.strandqvist@sonymobile.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Chen, Gong" <gong.chen@linux.intel.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: fbdev: sis: init.c:  Cleaning up variable that is
 never used
Message-ID: <20140705192317.GD25934@mwanda>
References: <1404564507-21718-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404564507-21718-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2014 at 02:48:27PM +0200, Rickard Strandqvist wrote:
> From: Rickard Strandqvist <rickard.strandqvist@sonymobile.com>

These for lines are for when you are sending on someone else's behalf.

> 
> Variable ar assigned a value that is never used.
> I have also removed all the code that thereby serves no purpose.
> 
> This was found using a static code analysis program called cppcheck
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/video/fbdev/sis/init.c |   21 +++++----------------
>  1 file changed, 5 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/video/fbdev/sis/init.c b/drivers/video/fbdev/sis/init.c
> index bd40f5e..3ba446c 100644
> --- a/drivers/video/fbdev/sis/init.c
> +++ b/drivers/video/fbdev/sis/init.c
> @@ -2649,7 +2649,7 @@ static void
>  SiS_SetCRT1ModeRegs(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
>  		unsigned short ModeIdIndex, unsigned short RRTI)
>  {
> -   unsigned short data, infoflag = 0, modeflag, resindex;
> +   unsigned short data, infoflag = 0, modeflag;
>  #ifdef CONFIG_FB_SIS_315
>     unsigned char  *ROMAddr  = SiS_Pr->VirtualRomBase;
>     unsigned short data2, data3;
> @@ -2660,7 +2660,7 @@ SiS_SetCRT1ModeRegs(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
>     if(SiS_Pr->UseCustomMode) {
>        infoflag = SiS_Pr->CInfoFlag;
>     } else {
> -      resindex = SiS_GetResInfo(SiS_Pr, ModeNo, ModeIdIndex);
> +      SiS_GetResInfo(SiS_Pr, ModeNo, ModeIdIndex);

Remove this whole line.

regards,
dan carpenter

