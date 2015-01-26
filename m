Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbbAZLi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:38:28 -0500
Received: from smtp65.iad3a.emailsrvr.com ([173.203.187.65]:36745 "EHLO
	smtp65.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753318AbbAZLiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:38:25 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54C6272E.4020509@mev.co.uk>
Date: Mon, 26 Jan 2015 11:38:22 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Simon Guo <wei.guo.simon@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.19.0-rc5 02/03] STAGING: Fix pcl818.c coding style issue:
 line over 80 characters
References: <20150125093042.GB4076@thunderCat>
In-Reply-To: <20150125093042.GB4076@thunderCat>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/01/15 09:30, Simon Guo wrote:
> Correct one coding style problem(detected by checkpatch.pl) in pcl818.c.
> - line over 80 characters
>
> Signed-off-by: Simon Guo <wei.guo.simon@gmail.com>
> ---
>   drivers/staging/comedi/drivers/pcl818.c | 14 ++++++++++----
>   1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
> index 72a700c..0873617 100644
> --- a/drivers/staging/comedi/drivers/pcl818.c
> +++ b/drivers/staging/comedi/drivers/pcl818.c
> @@ -304,9 +304,13 @@ static const struct pcl818_board boardtypes[] = {
>
>   struct pcl818_private {
>   	struct comedi_isadma *dma;
> -	unsigned int ns_min;	/*  manimal allowed delay between samples (in us) for actual card */
> +	unsigned int ns_min;	/*  manimal allowed delay between samples
> +				 *  (in us) for actual card
> +				 */

I'm not entirely sure what the preferred way of wrapping those comments 
is, but in other places in the comedi code we've been moving such 
comments to the previous line.

>   	int i8253_osc_base;	/*  1/frequency of on board oscilator in ns */
> -	unsigned int act_chanlist[16];	/*  MUX setting for actual AI operations */
> +	unsigned int act_chanlist[16];	/*  MUX setting for actual
> +					 *  AI operations
> +					 */
>   	unsigned int act_chanlist_len;	/*  how long is actual MUX list */
>   	unsigned int act_chanlist_pos;	/*  actual position in MUX list */
>   	unsigned int divisor1;
> @@ -648,7 +652,8 @@ static int check_channel_list(struct comedi_device *dev,
>   				break;
>   			nowmustbechan =
>   			    (CR_CHAN(chansegment[i - 1]) + 1) % s->n_chan;
> -			if (nowmustbechan != CR_CHAN(chanlist[i])) {	/*  channel list isn't continuous :-( */
> +			if (nowmustbechan != CR_CHAN(chanlist[i])) {
> +				/*  channel list isn't continuous :-( */
>   				dev_dbg(dev->class_dev,
>   					"channel list must be continuous! chanlist[%i]=%d but must be %d or %d!\n",
>   					i, CR_CHAN(chanlist[i]), nowmustbechan,
> @@ -1154,8 +1159,9 @@ static int pcl818_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>   	devpriv->ns_min = board->ns_min;
>
>   	if (!board->is_818) {
> +		/* extended PCL718 to 100kHz DAC */
>   		if ((it->options[6] == 1) || (it->options[6] == 100))
> -			devpriv->ns_min = 10000;	/* extended PCL718 to 100kHz DAC */
> +			devpriv->ns_min = 10000;

That comment really belongs inside the 'if' like this:

		if ((it->options[6] == 1) || (it->options[6] == 100)) {
			/* extended PCL718 to 100kHz DAC */
			devpriv->ns_min = 10000;
		}

>   	}
>
>   	pcl818_reset(dev);
>


-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
