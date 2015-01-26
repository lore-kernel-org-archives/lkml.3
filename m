Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbbAZOrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:47:17 -0500
Received: from smtp81.iad3a.emailsrvr.com ([173.203.187.81]:37570 "EHLO
	smtp81.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753901AbbAZOrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:47:14 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54C6536D.1050404@mev.co.uk>
Date: Mon, 26 Jan 2015 14:47:09 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Simon Guo <wei.guo.simon@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.19.0-rc5 02/03] STAGING: Fix pcl818.c coding style issue:
 line over 80 characters
References: <20150126131735.GB9183@thunderCat>
In-Reply-To: <20150126131735.GB9183@thunderCat>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/01/15 13:17, Simon Guo wrote:
> Correct one coding style problem(detected by checkpatch.pl) in pcl818.c.
> - line over 80 characters
>
> Signed-off-by: Simon Guo <wei.guo.simon@gmail.com>
> ---
>   drivers/staging/comedi/drivers/pcl818.c | 15 ++++++++++-----
>   1 file changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
> index 5a005e5..bc8493f 100644
> --- a/drivers/staging/comedi/drivers/pcl818.c
> +++ b/drivers/staging/comedi/drivers/pcl818.c
> @@ -303,9 +303,11 @@ static const struct pcl818_board boardtypes[] = {
>
>   struct pcl818_private {
>   	struct comedi_isadma *dma;
> -	unsigned int ns_min;	/*  manimal allowed delay between samples (in us) for actual card */
> +	/*  manimal allowed delay between samples (in us) for actual card */
> +	unsigned int ns_min;
>   	int i8253_osc_base;	/*  1/frequency of on board oscilator in ns */
> -	unsigned int act_chanlist[16];	/*  MUX setting for actual AI operations */
> +	/*  MUX setting for actual AI operations */
> +	unsigned int act_chanlist[16];
>   	unsigned int act_chanlist_len;	/*  how long is actual MUX list */
>   	unsigned int act_chanlist_pos;	/*  actual position in MUX list */
>   	unsigned int divisor1;
> @@ -647,7 +649,8 @@ static int check_channel_list(struct comedi_device *dev,
>   				break;
>   			nowmustbechan =
>   			    (CR_CHAN(chansegment[i - 1]) + 1) % s->n_chan;
> -			if (nowmustbechan != CR_CHAN(chanlist[i])) {	/*  channel list isn't continuous :-( */
> +			if (nowmustbechan != CR_CHAN(chanlist[i])) {
> +				/*  channel list isn't continuous :-( */
>   				dev_dbg(dev->class_dev,
>   					"channel list must be continuous! chanlist[%i]=%d but must be %d or %d!\n",
>   					i, CR_CHAN(chanlist[i]), nowmustbechan,
> @@ -1153,8 +1156,10 @@ static int pcl818_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>   	devpriv->ns_min = board->ns_min;
>
>   	if (!board->is_818) {
> -		if ((it->options[6] == 1) || (it->options[6] == 100))
> -			devpriv->ns_min = 10000;	/* extended PCL718 to 100kHz DAC */
> +		if ((it->options[6] == 1) || (it->options[6] == 100)) {
> +			/* extended PCL718 to 100kHz DAC */
> +			devpriv->ns_min = 10000;
> +		}
>   	}
>
>   	pcl818_reset(dev);
>

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
