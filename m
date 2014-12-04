Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbaLDWko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 17:40:44 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:51183 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705AbaLDWkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 17:40:42 -0500
Date: Thu, 4 Dec 2014 22:40:14 +0000
From: Luis de Bethencourt <luis@debethencourt.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-kernel@vger.kernel.org, jarod@wilsonet.com,
        gregkh@linuxfoundation.org, mahfouz.saif.elyazal@gmail.com,
        dan.carpenter@oracle.com, tuomas.tynkkynen@iki.fi,
        gulsah.1004@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH v2] staging: media: lirc: lirc_zilog.c: fix quoted
 strings split across lines
Message-ID: <20141204224014.GA17684@biggie>
References: <20141125203629.GA12059@biggie>
 <20141204131611.69d00ba1.m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141204131611.69d00ba1.m.chehab@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 01:16:11PM -0200, Mauro Carvalho Chehab wrote:
> Hi Luis,
> 
> Em Tue, 25 Nov 2014 20:36:29 +0000
> Luis de Bethencourt <luis@debethencourt.com> escreveu:
> 
> > checkpatch makes an exception to the 80-colum rule for quotes strings, and
> > Documentation/CodingStyle recommends not splitting quotes strings across lines
> > because it breaks the ability to grep for the string. Fixing these.
> > 
> > WARNING: quoted string split across lines
> > 
> > Signed-off-by: Luis de Bethencourt <luis@debethencourt.com>
> > ---
> > Changes in v2:
> > 	- As pointed out by Joe Perches I missed a space when joining a set of strings
> > 
> > Thanks for the review Joe
> >  drivers/staging/media/lirc/lirc_zilog.c | 39 ++++++++++++++-------------------
> >  1 file changed, 17 insertions(+), 22 deletions(-)
> > 
> > diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
> > index dca806a..a35d6f2 100644
> > --- a/drivers/staging/media/lirc/lirc_zilog.c
> > +++ b/drivers/staging/media/lirc/lirc_zilog.c
> > @@ -372,14 +372,12 @@ static int add_to_buf(struct IR *ir)
> >  					   ret);
> >  			if (failures >= 3) {
> >  				mutex_unlock(&ir->ir_lock);
> > -				dev_err(ir->l.dev, "unable to read from the IR chip "
> > -					    "after 3 resets, giving up\n");
> > +				dev_err(ir->l.dev, "unable to read from the IR chip after 3 resets, giving up\n");
> 
> This patch didn't apply on my tree, as what I have there is a driver
> custom macro. Probably I'm missing some patch (or it got merged via some
> other tree):

Hi Mauro,

The patch is against Greg's staging-testing branch. If you want it against any
of your branches let me know and I will fix it.

> 
> +<<<<<<<
>                                 zilog_error("unable to read from the IR chip "
>                                             "after 3 resets, giving up\n");
> +=======
> +                               dev_err(ir->l.dev, "unable to read from the IR chip after 3 resets, giving up\n");
> +>>>>>>>
> 
> One general note about this patch: those strings are already big, so
> the best is to put them at the beginning of the second line, aligned with
> the parenthesis, e. g:
> 				dev_err(ir->l.dev,
> 					"unable to read from the IR chip after 3 resets, giving up\n");
> 
> Ok, on some, the second line will still violate the 80-cols max, but
> on others it may actually fit. So, better to do the same thing along
> the entire driver, as it makes easier to read it if all similar lines
> use the same criteria.

I just sent two patches. The first one changes the original patch to follow the
format you suggest here. The second one changes the rest of the driver to be
consisent with this.

Thanks a lot for the review :)
Luis

> 
> Regards,
> Mauro.
> 
> >  				break;
> >  			}
> >  
> >  			/* Looks like the chip crashed, reset it */
> > -			dev_err(ir->l.dev, "polling the IR receiver chip failed, "
> > -				    "trying reset\n");
> > +			dev_err(ir->l.dev, "polling the IR receiver chip failed, trying reset\n");
> >  
> >  			set_current_state(TASK_UNINTERRUPTIBLE);
> >  			if (kthread_should_stop()) {
> > @@ -405,8 +403,8 @@ static int add_to_buf(struct IR *ir)
> >  		ret = i2c_master_recv(rx->c, keybuf, sizeof(keybuf));
> >  		mutex_unlock(&ir->ir_lock);
> >  		if (ret != sizeof(keybuf)) {
> > -			dev_err(ir->l.dev, "i2c_master_recv failed with %d -- "
> > -				    "keeping last read buffer\n", ret);
> > +			dev_err(ir->l.dev, "i2c_master_recv failed with %d -- keeping last read buffer\n",
> > +				    ret);
> >  		} else {
> >  			rx->b[0] = keybuf[3];
> >  			rx->b[1] = keybuf[4];
> > @@ -713,8 +711,8 @@ static int send_boot_data(struct IR_tx *tx)
> >  				       buf[0]);
> >  		return 0;
> >  	}
> > -	dev_notice(tx->ir->l.dev, "Zilog/Hauppauge IR blaster firmware version "
> > -		     "%d.%d.%d loaded\n", buf[1], buf[2], buf[3]);
> > +	dev_notice(tx->ir->l.dev, "Zilog/Hauppauge IR blaster firmware version %d.%d.%d loaded\n",
> > +		     buf[1], buf[2], buf[3]);
> >  
> >  	return 0;
> >  }
> > @@ -794,8 +792,7 @@ static int fw_load(struct IR_tx *tx)
> >  	if (!read_uint8(&data, tx_data->endp, &version))
> >  		goto corrupt;
> >  	if (version != 1) {
> > -		dev_err(tx->ir->l.dev, "unsupported code set file version (%u, expected"
> > -			    "1) -- please upgrade to a newer driver",
> > +		dev_err(tx->ir->l.dev, "unsupported code set file version (%u, expected 1) -- please upgrade to a newer driver",
> >  			    version);
> >  		fw_unload_locked();
> >  		ret = -EFAULT;
> > @@ -983,8 +980,8 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
> >  	ret = get_key_data(data_block, code, key);
> >  
> >  	if (ret == -EPROTO) {
> > -		dev_err(tx->ir->l.dev, "failed to get data for code %u, key %u -- check "
> > -			    "lircd.conf entries\n", code, key);
> > +		dev_err(tx->ir->l.dev, "failed to get data for code %u, key %u -- check lircd.conf entries\n",
> > +			    code, key);
> >  		return ret;
> >  	} else if (ret != 0)
> >  		return ret;
> > @@ -1059,8 +1056,8 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
> >  		ret = i2c_master_send(tx->c, buf, 1);
> >  		if (ret == 1)
> >  			break;
> > -		dev_dbg(tx->ir->l.dev, "NAK expected: i2c_master_send "
> > -			"failed with %d (try %d)\n", ret, i+1);
> > +		dev_dbg(tx->ir->l.dev, "NAK expected: i2c_master_send failed with %d (try %d)\n",
> > +			ret, i+1);
> >  	}
> >  	if (ret != 1) {
> >  		dev_err(tx->ir->l.dev, "IR TX chip never got ready: last i2c_master_send "
> > @@ -1167,12 +1164,10 @@ static ssize_t write(struct file *filep, const char __user *buf, size_t n,
> >  		 */
> >  		if (ret != 0) {
> >  			/* Looks like the chip crashed, reset it */
> > -			dev_err(tx->ir->l.dev, "sending to the IR transmitter chip "
> > -				    "failed, trying reset\n");
> > +			dev_err(tx->ir->l.dev, "sending to the IR transmitter chip failed, trying reset\n");
> >  
> >  			if (failures >= 3) {
> > -				dev_err(tx->ir->l.dev, "unable to send to the IR chip "
> > -					    "after 3 resets, giving up\n");
> > +				dev_err(tx->ir->l.dev, "unable to send to the IR chip after 3 resets, giving up\n");
> >  				mutex_unlock(&ir->ir_lock);
> >  				mutex_unlock(&tx->client_lock);
> >  				put_ir_tx(tx, false);
> > @@ -1581,8 +1576,8 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
> >  				       "zilog-rx-i2c-%d", adap->nr);
> >  		if (IS_ERR(rx->task)) {
> >  			ret = PTR_ERR(rx->task);
> > -			dev_err(tx->ir->l.dev, "%s: could not start IR Rx polling thread"
> > -				    "\n", __func__);
> > +			dev_err(tx->ir->l.dev, "%s: could not start IR Rx polling thread\n",
> > +				    __func__);
> >  			/* Failed kthread, so put back the ir ref */
> >  			put_ir_device(ir, true);
> >  			/* Failure exit, so put back rx ref from i2c_client */
> > @@ -1594,8 +1589,8 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
> >  
> >  		/* Proceed only if the Tx client is also ready */
> >  		if (tx == NULL) {
> > -			pr_info("probe of IR Rx on %s (i2c-%d) done. Waiting"
> > -				   " on IR Tx.\n", adap->name, adap->nr);
> > +			pr_info("probe of IR Rx on %s (i2c-%d) done. Waiting on IR Tx.\n",
> > +				   adap->name, adap->nr);
> >  			goto out_ok;
> >  		}
> >  	}
