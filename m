Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967002AbaFTLMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 07:12:41 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:49535 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965558AbaFTLMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 07:12:39 -0400
Message-ID: <53A41720.9020609@mev.co.uk>
Date: Fri, 20 Jun 2014 12:12:32 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux-Next <linux-next@vger.kernel.org>
Subject: Re: [-next] comedi I/O accessor name clashes
References: <CAMuHMdVhU6JZFzuPkx=wtLcPYc7wwaMFwCrZu=zG7PmCYssy-g@mail.gmail.com>
In-Reply-To: <CAMuHMdVhU6JZFzuPkx=wtLcPYc7wwaMFwCrZu=zG7PmCYssy-g@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-20 12:07, Geert Uytterhoeven wrote:
> commit 9c340ac934dbbfd46e776465b08391baac32d486
> Author: H Hartley Sweeten <hsweeten@visionengravers.com>
> Date:   Thu May 29 10:56:32 2014 -0700
>
>      staging: comedi: ni_stc.h: add read/write callbacks to struct ni_private
>
> --- a/drivers/staging/comedi/drivers/ni_stc.h
> +++ b/drivers/staging/comedi/drivers/ni_stc.h
> @@ -1421,6 +1421,13 @@ struct ni_board_struct {
>   #define NUM_GPCT       2
>
>   struct ni_private {
> +       uint8_t (*readb)(struct comedi_device *, int reg);
> +       uint16_t (*readw)(struct comedi_device *, int reg);
> +       uint32_t (*readl)(struct comedi_device *, int reg);
> +       void (*writeb)(struct comedi_device *, uint8_t value, int reg);
> +       void (*writew)(struct comedi_device *, uint16_t value, int reg);
> +       void (*writel)(struct comedi_device *, uint32_t value, int reg);
> +
>          uint16_t (*stc_readw)(struct comedi_device *, int reg);
>          uint32_t (*stc_readl)(struct comedi_device *, int reg);
>          void (*stc_writew)(struct comedi_device *, uint16_t value, int reg);
>
> However, on several architectures, writel() and friends are macros, causing:
>
> drivers/staging/comedi/drivers/ni_atmio.c:318:38: error: macro
> "writew" passed 3 arguments, but takes just 2
>
> m68k http://kisskb.ellerman.id.au/kisskb/buildresult/11346953/
> s390 kisskb.ellerman.id.au/kisskb/buildresult/11347163/
> sparc64 kisskb.ellerman.id.au/kisskb/buildresult/11347152/
> xtensa http://kisskb.ellerman.id.au/kisskb/buildresult/11346651/
>
> Gr{oetje,eeting}s,
>
>                          Geert

Thanks, but Hartley has already fixed it and Greg has applied it to his 
staging-next branch.  It should wend it's merry way to linux-next in the 
not-too-distant future.

Cheers,
Ian.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
