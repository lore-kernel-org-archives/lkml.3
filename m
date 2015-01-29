Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965430AbbA2CiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:38:07 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:39041 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965382AbbA2Ch5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:37:57 -0500
MIME-Version: 1.0
In-Reply-To: <1422484960-10266-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1422484960-10266-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Wed, 28 Jan 2015 20:37:56 -0600
X-Google-Sender-Auth: MMqY_CrS8eWh1vJfQuM2wa8NtLI
Message-ID: <CAEUsAPZgbticL2SkSQUoj7B_2VLDSrYrAFVdH5e8QdCd9vJNoQ@mail.gmail.com>
Subject: Re: [PATCH] staging: emxx_udc: emxx_udc: Removed variables that is
 never used
From: Chris Rorvick <chris@rorvick.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincenzo Scotti <vinc94@gmail.com>,
        Roberta Dobrescu <roberta.dobrescu@gmail.com>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Ebru Akagunduz <ebru.akagunduz@gmail.com>,
        Magnus Damm <damm+renesas@opensource.se>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 4:42 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> Variable ar assigned a value that is never used.
> I have also removed all the code that thereby serves no purpose.

Each of these changes adds a warning ...

> diff --git a/drivers/staging/emxx_udc/emxx_udc.c b/drivers/staging/emxx_udc/emxx_udc.c
> index eb178fc..b916fab 100644
> --- a/drivers/staging/emxx_udc/emxx_udc.c
> +++ b/drivers/staging/emxx_udc/emxx_udc.c
> @@ -2974,10 +2974,10 @@ static int nbu2ss_ep_fifo_status(struct usb_ep *_ep)
>         spin_lock_irqsave(&udc->lock, flags);
>
>         if (ep->epnum == 0) {
> -               data = _nbu2ss_readl(&preg->EP0_LENGTH) & EP0_LDATA;
> +               _nbu2ss_readl(&preg->EP0_LENGTH) & EP0_LDATA;

.../linux/drivers/staging/emxx_udc/emxx_udc.c:2977:36: warning: value
computed is not used [-Wunused-value]
   _nbu2ss_readl(&preg->EP0_LENGTH) & EP0_LDATA;
                                    ^

>         } else {
> -               data = _nbu2ss_readl(&preg->EP_REGS[ep->epnum-1].EP_LEN_DCNT)
> +               _nbu2ss_readl(&preg->EP_REGS[ep->epnum-1].EP_LEN_DCNT)
>                         & EPn_LDATA;

.../linux/drivers/staging/emxx_udc/emxx_udc.c:2981:4: warning: value
computed is not used [-Wunused-value]
    & EPn_LDATA;
    ^

>         }
>
> @@ -3264,12 +3264,11 @@ static void __init nbu2ss_drv_set_ep_info(
>         if (isdigit(name[2])) {
>
>                 long    num;
> -               int     res;
>                 char    tempbuf[2];
>
>                 tempbuf[0] = name[2];
>                 tempbuf[1] = '\0';
> -               res = kstrtol(tempbuf, 16, &num);
> +               kstrtol(tempbuf, 16, &num);

.../linux/drivers/staging/emxx_udc/emxx_udc.c:3271:3: warning:
ignoring return value of ‘kstrtol’, declared with attribute
warn_unused_result [-Wunused-result]
   kstrtol(tempbuf, 16, &num);
   ^
