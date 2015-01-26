Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbbAZOqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:46:38 -0500
Received: from smtp65.iad3a.emailsrvr.com ([173.203.187.65]:52999 "EHLO
	smtp65.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752845AbbAZOqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:46:36 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54C6533A.2020007@mev.co.uk>
Date: Mon, 26 Jan 2015 14:46:18 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Simon Guo <wei.guo.simon@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.19.0-rc5 01/03] STAGING: Fix pcl818.c coding style issue:
 code indent should use tabs where possible
References: <20150126131627.GA9183@thunderCat>
In-Reply-To: <20150126131627.GA9183@thunderCat>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/01/15 13:16, Simon Guo wrote:
> Correct one coding style problem(detected by checkpatch.pl) in pcl818.c.
> - code indent should use tabs where possible
> It is fixed by reformatting the comment block to usual comment style.
>
> Signed-off-by: Simon Guo <wei.guo.simon@gmail.com>
> ---
>   drivers/staging/comedi/drivers/pcl818.c | 195 ++++++++++++++++----------------
>   1 file changed, 97 insertions(+), 98 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
> index ba2e137..5a005e5 100644
> --- a/drivers/staging/comedi/drivers/pcl818.c
> +++ b/drivers/staging/comedi/drivers/pcl818.c
> @@ -1,102 +1,101 @@
>   /*
> -   comedi/drivers/pcl818.c
> -
> -   Author:  Michal Dobes <dobes@tesnet.cz>
> -
> -   hardware driver for Advantech cards:
> -    card:   PCL-818L, PCL-818H, PCL-818HD, PCL-818HG, PCL-818, PCL-718
> -    driver: pcl818l,  pcl818h,  pcl818hd,  pcl818hg,  pcl818,  pcl718
> -*/
> -/*
> -Driver: pcl818
> -Description: Advantech PCL-818 cards, PCL-718
> -Author: Michal Dobes <dobes@tesnet.cz>
> -Devices: [Advantech] PCL-818L (pcl818l), PCL-818H (pcl818h),
> -  PCL-818HD (pcl818hd), PCL-818HG (pcl818hg), PCL-818 (pcl818),
> -  PCL-718 (pcl718)
> -Status: works
> -
> -All cards have 16 SE/8 DIFF ADCs, one or two DACs, 16 DI and 16 DO.
> -Differences are only at maximal sample speed, range list and FIFO
> -support.
> -The driver support AI mode 0, 1, 3 other subdevices (AO, DI, DO) support
> -only mode 0. If DMA/FIFO/INT are disabled then AI support only mode 0.
> -PCL-818HD and PCL-818HG support 1kword FIFO. Driver support this FIFO
> -but this code is untested.
> -A word or two about DMA. Driver support DMA operations at two ways:
> -1) DMA uses two buffers and after one is filled then is generated
> -   INT and DMA restart with second buffer. With this mode I'm unable run
> -   more that 80Ksamples/secs without data dropouts on K6/233.
> -2) DMA uses one buffer and run in autoinit mode and the data are
> -   from DMA buffer moved on the fly with 2kHz interrupts from RTC.
> -   This mode is used if the interrupt 8 is available for allocation.
> -   If not, then first DMA mode is used. With this I can run at
> -   full speed one card (100ksamples/secs) or two cards with
> -   60ksamples/secs each (more is problem on account of ISA limitations).
> -   To use this mode you must have compiled  kernel with disabled
> -   "Enhanced Real Time Clock Support".
> -   Maybe you can have problems if you use xntpd or similar.
> -   If you've data dropouts with DMA mode 2 then:
> -    a) disable IDE DMA
> -    b) switch text mode console to fb.
> -
> -   Options for PCL-818L:
> -    [0] - IO Base
> -    [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
> -    [2] - DMA	(0=disable, 1, 3)
> -    [3] - 0, 10=10MHz clock for 8254
> -              1= 1MHz clock for 8254
> -    [4] - 0,  5=A/D input  -5V.. +5V
> -          1, 10=A/D input -10V..+10V
> -    [5] - 0,  5=D/A output 0-5V  (internal reference -5V)
> -          1, 10=D/A output 0-10V (internal reference -10V)
> -	  2    =D/A output unknown (external reference)
> -
> -   Options for PCL-818, PCL-818H:
> -    [0] - IO Base
> -    [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
> -    [2] - DMA	(0=disable, 1, 3)
> -    [3] - 0, 10=10MHz clock for 8254
> -              1= 1MHz clock for 8254
> -    [4] - 0,  5=D/A output 0-5V  (internal reference -5V)
> -          1, 10=D/A output 0-10V (internal reference -10V)
> -	  2    =D/A output unknown (external reference)
> -
> -   Options for PCL-818HD, PCL-818HG:
> -    [0] - IO Base
> -    [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
> -    [2] - DMA/FIFO  (-1=use FIFO, 0=disable both FIFO and DMA,
> -                      1=use DMA ch 1, 3=use DMA ch 3)
> -    [3] - 0, 10=10MHz clock for 8254
> -              1= 1MHz clock for 8254
> -    [4] - 0,  5=D/A output 0-5V  (internal reference -5V)
> -          1, 10=D/A output 0-10V (internal reference -10V)
> -   	  2    =D/A output unknown (external reference)
> -
> -   Options for PCL-718:
> -    [0] - IO Base
> -    [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
> -    [2] - DMA	(0=disable, 1, 3)
> -    [3] - 0, 10=10MHz clock for 8254
> -              1= 1MHz clock for 8254
> -    [4] -     0=A/D Range is +/-10V
> -	      1=             +/-5V
> -	      2=             +/-2.5V
> -	      3=             +/-1V
> -	      4=             +/-0.5V
> -	      5=  	     user defined bipolar
> -	      6=	     0-10V
> -	      7=	     0-5V
> - 	      8=	     0-2V
> -	      9=	     0-1V
> -	     10=	     user defined unipolar
> -    [5] - 0,  5=D/A outputs 0-5V  (internal reference -5V)
> -          1, 10=D/A outputs 0-10V (internal reference -10V)
> -	      2=D/A outputs unknown (external reference)
> -    [6] - 0, 60=max  60kHz A/D sampling
> -          1,100=max 100kHz A/D sampling (PCL-718 with Option 001 installed)
> -
> -*/
> + * comedi/drivers/pcl818.c
> + *
> + * Author:  Michal Dobes <dobes@tesnet.cz>
> + *
> + * hardware driver for Advantech cards:
> + *  card:   PCL-818L, PCL-818H, PCL-818HD, PCL-818HG, PCL-818, PCL-718
> + *  driver: pcl818l,  pcl818h,  pcl818hd,  pcl818hg,  pcl818,  pcl718
> +

It shouldn't have a completely blank line there, it should either be 
plugged up with a ' *' at the start, or the comment should be split into 
two at that point.

Actually, most of the above part of the comment is pretty superfluous as 
the information is effectively repeated in the part below.  You could 
remove all but the "file location" line.

> + * Driver: pcl818
> + * Description: Advantech PCL-818 cards, PCL-718
> + * Author: Michal Dobes <dobes@tesnet.cz>
> + * Devices: [Advantech] PCL-818L (pcl818l), PCL-818H (pcl818h),
> + *   PCL-818HD (pcl818hd), PCL-818HG (pcl818hg), PCL-818 (pcl818),
> + *   PCL-718 (pcl718)
> + * Status: works
> + *
> + * All cards have 16 SE/8 DIFF ADCs, one or two DACs, 16 DI and 16 DO.
> + * Differences are only at maximal sample speed, range list and FIFO
> + * support.
> + * The driver support AI mode 0, 1, 3 other subdevices (AO, DI, DO) support
> + * only mode 0. If DMA/FIFO/INT are disabled then AI support only mode 0.
> + * PCL-818HD and PCL-818HG support 1kword FIFO. Driver support this FIFO
> + * but this code is untested.
> + * A word or two about DMA. Driver support DMA operations at two ways:
> + * 1) DMA uses two buffers and after one is filled then is generated
> + *    INT and DMA restart with second buffer. With this mode I'm unable run
> + *    more that 80Ksamples/secs without data dropouts on K6/233.
> + * 2) DMA uses one buffer and run in autoinit mode and the data are
> + *    from DMA buffer moved on the fly with 2kHz interrupts from RTC.
> + *    This mode is used if the interrupt 8 is available for allocation.
> + *    If not, then first DMA mode is used. With this I can run at
> + *    full speed one card (100ksamples/secs) or two cards with
> + *    60ksamples/secs each (more is problem on account of ISA limitations).
> + *    To use this mode you must have compiled  kernel with disabled
> + *    "Enhanced Real Time Clock Support".
> + *    Maybe you can have problems if you use xntpd or similar.
> + *    If you've data dropouts with DMA mode 2 then:
> + *     a) disable IDE DMA
> + *     b) switch text mode console to fb.
> + *

Since you're reformatting this anyway, it would be better if all the 
stuff below this point was shifted two spaces to the left as there is no 
logical need for extra indentation here.  Also, if you can expand any 
tabs below, you can drop your patch 3.

> + *    Options for PCL-818L:
> + *     [0] - IO Base
> + *     [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
> + *     [2] - DMA	(0=disable, 1, 3)
> + *     [3] - 0, 10=10MHz clock for 8254
> + *               1= 1MHz clock for 8254
> + *     [4] - 0,  5=A/D input  -5V.. +5V
> + *           1, 10=A/D input -10V..+10V
> + *     [5] - 0,  5=D/A output 0-5V  (internal reference -5V)
> + *           1, 10=D/A output 0-10V (internal reference -10V)
> + *           2    =D/A output unknown (external reference)
> + *
> + *    Options for PCL-818, PCL-818H:
> + *     [0] - IO Base
> + *     [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
> + *     [2] - DMA	(0=disable, 1, 3)
> + *     [3] - 0, 10=10MHz clock for 8254
> + *               1= 1MHz clock for 8254
> + *     [4] - 0,  5=D/A output 0-5V  (internal reference -5V)
> + *           1, 10=D/A output 0-10V (internal reference -10V)
> + *           2    =D/A output unknown (external reference)
> + *
> + *    Options for PCL-818HD, PCL-818HG:
> + *     [0] - IO Base
> + *     [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
> + *     [2] - DMA/FIFO  (-1=use FIFO, 0=disable both FIFO and DMA,
> + *                       1=use DMA ch 1, 3=use DMA ch 3)
> + *     [3] - 0, 10=10MHz clock for 8254
> + *               1= 1MHz clock for 8254
> + *     [4] - 0,  5=D/A output 0-5V  (internal reference -5V)
> + *           1, 10=D/A output 0-10V (internal reference -10V)
> + *           2    =D/A output unknown (external reference)
> + *
> + *    Options for PCL-718:
> + *     [0] - IO Base
> + *     [1] - IRQ	(0=disable, 2, 3, 4, 5, 6, 7)
> + *     [2] - DMA	(0=disable, 1, 3)
> + *     [3] - 0, 10=10MHz clock for 8254
> + *               1= 1MHz clock for 8254
> + *     [4] -     0=A/D Range is +/-10V
> + *               1=             +/-5V
> + *               2=             +/-2.5V
> + *               3=             +/-1V
> + *               4=             +/-0.5V
> + *               5=  	     user defined bipolar
> + *               6=	     0-10V
> + *               7=	     0-5V
> + *               8=	     0-2V
> + *               9=	     0-1V
> + *              10=	     user defined unipolar
> + *     [5] - 0,  5=D/A outputs 0-5V  (internal reference -5V)
> + *           1, 10=D/A outputs 0-10V (internal reference -10V)
> + *               2=D/A outputs unknown (external reference)
> + *     [6] - 0, 60=max  60kHz A/D sampling
> + *           1,100=max 100kHz A/D sampling (PCL-718 with Option 001 installed)
> + *
> + */
>
>   #include <linux/module.h>
>   #include <linux/gfp.h>
>


-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
