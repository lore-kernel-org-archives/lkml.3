Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbbAVMoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 07:44:46 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:64959 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbbAVMol convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 07:44:41 -0500
MIME-Version: 1.0
In-Reply-To: <61a7298a0767084d7b8b335bbe2116c287f72459.1421115389.git.shuahkh@osg.samsung.com>
References: <cover.1421115389.git.shuahkh@osg.samsung.com> <61a7298a0767084d7b8b335bbe2116c287f72459.1421115389.git.shuahkh@osg.samsung.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Thu, 22 Jan 2015 12:44:10 +0000
Message-ID: <CA+V-a8s=gESbkcXa73hqaMt8c5AaR=gWcO+fd-Emo3iwW6-dHg@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] media: fix au0828 compile error from au0828_boards initialization
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        laurent pinchart <laurent.pinchart@ideasonboard.com>,
        Tim Mester <ttmesterr@gmail.com>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shuah,

Thanks for the patch.

On Tue, Jan 13, 2015 at 2:56 AM, Shuah Khan <shuahkh@osg.samsung.com> wrote:
> au0828 picked up UNSET from videobuf-core.h and fails to compile
> if videobuf-core.h isn't included. Change it to use -1U instead
> to fix the problem.
>
>     drivers/media/usb/au0828/au0828-cards.c:47:17: error: ‘UNSET’ undeclared here (not in a function)
>        .tuner_type = UNSET,
>
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad

> ---
>  drivers/media/usb/au0828/au0828-cards.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/au0828/au0828-cards.c b/drivers/media/usb/au0828/au0828-cards.c
> index da87f1c..edc2735 100644
> --- a/drivers/media/usb/au0828/au0828-cards.c
> +++ b/drivers/media/usb/au0828/au0828-cards.c
> @@ -44,7 +44,7 @@ static void hvr950q_cs5340_audio(void *priv, int enable)
>  struct au0828_board au0828_boards[] = {
>         [AU0828_BOARD_UNKNOWN] = {
>                 .name   = "Unknown board",
> -               .tuner_type = UNSET,
> +               .tuner_type = -1U,
>                 .tuner_addr = ADDR_UNSET,
>         },
>         [AU0828_BOARD_HAUPPAUGE_HVR850] = {
> --
> 2.1.0
>
