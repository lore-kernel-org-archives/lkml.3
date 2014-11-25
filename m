Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaKYVOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:14:48 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:50634 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaKYVOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:14:45 -0500
Date: Tue, 25 Nov 2014 21:14:28 +0000
From: Luis de Bethencourt <luis@debethencourt.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, jarod@wilsonet.com, m.chehab@samsung.com,
        gregkh@linuxfoundation.org, mahfouz.saif.elyazal@gmail.com,
        dan.carpenter@oracle.com, tuomas.tynkkynen@iki.fi,
        gulsah.1004@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: media: lirc: lirc_zilog.c: fix quoted strings
 split across lines
Message-ID: <20141125211428.GA12346@biggie>
References: <20141125201905.GA10900@biggie>
 <1416947244.8358.12.camel@perches.com>
 <20141125204056.GA12162@biggie>
 <1416949207.8358.14.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416949207.8358.14.camel@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 01:00:07PM -0800, Joe Perches wrote:
> On Tue, 2014-11-25 at 20:40 +0000, Luis de Bethencourt wrote:
> > On Tue, Nov 25, 2014 at 12:27:24PM -0800, Joe Perches wrote:
> > > On Tue, 2014-11-25 at 20:19 +0000, Luis de Bethencourt wrote:
> > > > checkpatch makes an exception to the 80-colum rule for quotes strings, and
> > > > Documentation/CodingStyle recommends not splitting quotes strings across lines
> > > > because it breaks the ability to grep for the string. Fixing these.
> > > []
> > > > diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
> > > []
> > > > @@ -794,8 +792,7 @@ static int fw_load(struct IR_tx *tx)
> > > >  	if (!read_uint8(&data, tx_data->endp, &version))
> > > >  		goto corrupt;
> > > >  	if (version != 1) {
> > > > -		dev_err(tx->ir->l.dev, "unsupported code set file version (%u, expected"
> > > > -			    "1) -- please upgrade to a newer driver",
> > > > +		dev_err(tx->ir->l.dev, "unsupported code set file version (%u, expected1) -- please upgrade to a newer driver",
> > > >  			    version);
> > > 
> > > Hello Luis.
> > > 
> > > Please look at the strings being coalesced before
> > > submitting patches.
> > > 
> > > It's a fairly common defect to have either a missing
> > > space between the coalesced fragments or too mano
> > > spaces.
> > > 
> > > It's almost certain that there should be a space
> > > between the "expected" and "1" here.
> > > 
> > > 
> > 
> > Hello Joe,
> > 
> > Thanks for taking the time to review this. I sent a new
> > version fixing the missing space. 
> 
> Thanks.
> 
> In the future, you might consider being more
> comprehensive with your patches.

Wasn't sure about the scope of the style fixing
patches. I've been reading Kernel Newbies and
this looked like a good way to start
contributing. Good to know more exhaustive
changes are welcome.

> 
> This code could be neatened a bit by:
> 
> o using another set of logging macros
> o removing the unnecessary ftrace like logging
> o realigning arguments

Great ideas.
Should this have been all included in one patch,
or each as part of a series with the previous
one?
Want to take the opportunity to learn about the
process.

> 
> Something like:
> 
> ---
>  drivers/staging/media/lirc/lirc_zilog.c | 151 +++++++++++++++-----------------
>  1 file changed, 73 insertions(+), 78 deletions(-)
> 
> diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
> index bebb9f1..523af12 100644
> --- a/drivers/staging/media/lirc/lirc_zilog.c
> +++ b/drivers/staging/media/lirc/lirc_zilog.c
> @@ -158,6 +158,17 @@ static bool debug;	/* debug output */
>  static bool tx_only;	/* only handle the IR Tx function */
>  static int minor = -1;	/* minor number */
>  
> +/* logging macros */
> +#define ir_err(ir, fmt, ...)				\
> +	dev_err((ir)->l.dev, fmt, ##__VA_ARGS__)
> +#define ir_warn(ir, fmt, ...)				\
> +	dev_warn((ir)->l.dev, fmt, ##__VA_ARGS__)
> +#define ir_notice(ir, fmt, ...)				\
> +	dev_notice((ir)->l.dev, fmt, ##__VA_ARGS__)
> +#define ir_info(ir, fmt, ...)				\
> +	dev_info((ir)->l.dev, fmt, ##__VA_ARGS__)
> +#define ir_dbg(ir, fmt, ...)				\
> +	dev_dbg((ir)->l.dev, fmt, ##__VA_ARGS__)
>  
>  /* struct IR reference counting */
>  static struct IR *get_ir_device(struct IR *ir, bool ir_devices_lock_held)
> @@ -322,7 +333,7 @@ static int add_to_buf(struct IR *ir)
>  	struct IR_tx *tx;
>  
>  	if (lirc_buffer_full(rbuf)) {
> -		dev_dbg(ir->l.dev, "buffer overflow\n");
> +		ir_dbg(ir, "buffer overflow\n");
>  		return -EOVERFLOW;
>  	}
>  
> @@ -368,18 +379,15 @@ static int add_to_buf(struct IR *ir)
>  		 */
>  		ret = i2c_master_send(rx->c, sendbuf, 1);
>  		if (ret != 1) {
> -			dev_err(ir->l.dev, "i2c_master_send failed with %d\n",
> -					   ret);
> +			ir_err(ir, "i2c_master_send failed with %d\n", ret);
>  			if (failures >= 3) {
>  				mutex_unlock(&ir->ir_lock);
> -				dev_err(ir->l.dev, "unable to read from the IR chip "
> -					    "after 3 resets, giving up\n");
> +				ir_err(ir, "unable to read from the IR chip after 3 resets, giving up\n");
>  				break;
>  			}
>  
>  			/* Looks like the chip crashed, reset it */
> -			dev_err(ir->l.dev, "polling the IR receiver chip failed, "
> -				    "trying reset\n");
> +			ir_err(ir, "polling the IR receiver chip failed, trying reset\n");
>  
>  			set_current_state(TASK_UNINTERRUPTIBLE);
>  			if (kthread_should_stop()) {
> @@ -405,14 +413,13 @@ static int add_to_buf(struct IR *ir)
>  		ret = i2c_master_recv(rx->c, keybuf, sizeof(keybuf));
>  		mutex_unlock(&ir->ir_lock);
>  		if (ret != sizeof(keybuf)) {
> -			dev_err(ir->l.dev, "i2c_master_recv failed with %d -- "
> -				    "keeping last read buffer\n", ret);
> +			ir_err(ir, "i2c_master_recv failed with %d -- keeping last read buffer\n",
> +			       ret);
>  		} else {
>  			rx->b[0] = keybuf[3];
>  			rx->b[1] = keybuf[4];
>  			rx->b[2] = keybuf[5];
> -			dev_dbg(ir->l.dev, "key (0x%02x/0x%02x)\n",
> -					   rx->b[0], rx->b[1]);
> +			ir_dbg(ir, "key (0x%02x/0x%02x)\n", rx->b[0], rx->b[1]);
>  		}
>  
>  		/* key pressed ? */
> @@ -463,7 +470,7 @@ static int lirc_thread(void *arg)
>  	struct IR *ir = arg;
>  	struct lirc_buffer *rbuf = ir->l.rbuf;
>  
> -	dev_dbg(ir->l.dev, "poll thread started\n");
> +	ir_dbg(ir, "poll thread started\n");
>  
>  	while (!kthread_should_stop()) {
>  		set_current_state(TASK_INTERRUPTIBLE);
> @@ -491,7 +498,7 @@ static int lirc_thread(void *arg)
>  			wake_up_interruptible(&rbuf->wait_poll);
>  	}
>  
> -	dev_dbg(ir->l.dev, "poll thread ended\n");
> +	ir_dbg(ir, "poll thread ended\n");
>  	return 0;
>  }
>  
> @@ -653,11 +660,10 @@ static int send_data_block(struct IR_tx *tx, unsigned char *data_block)
>  		buf[0] = (unsigned char)(i + 1);
>  		for (j = 0; j < tosend; ++j)
>  			buf[1 + j] = data_block[i + j];
> -		dev_dbg(tx->ir->l.dev, "%*ph", 5, buf);
> +		ir_dbg(tx->ir, "%*ph\n", 5, buf);
>  		ret = i2c_master_send(tx->c, buf, tosend + 1);
>  		if (ret != tosend + 1) {
> -			dev_err(tx->ir->l.dev, "i2c_master_send failed with %d\n",
> -					       ret);
> +			ir_err(tx->ir, "i2c_master_send failed with %d\n", ret);
>  			return ret < 0 ? ret : -EFAULT;
>  		}
>  		i += tosend;
> @@ -681,7 +687,7 @@ static int send_boot_data(struct IR_tx *tx)
>  	buf[1] = 0x20;
>  	ret = i2c_master_send(tx->c, buf, 2);
>  	if (ret != 2) {
> -		dev_err(tx->ir->l.dev, "i2c_master_send failed with %d\n", ret);
> +		ir_err(tx->ir, "i2c_master_send failed with %d\n", ret);
>  		return ret < 0 ? ret : -EFAULT;
>  	}
>  
> @@ -698,23 +704,23 @@ static int send_boot_data(struct IR_tx *tx)
>  	}
>  
>  	if (ret != 1) {
> -		dev_err(tx->ir->l.dev, "i2c_master_send failed with %d\n", ret);
> +		ir_err(tx->ir, "i2c_master_send failed with %d\n", ret);
>  		return ret < 0 ? ret : -EFAULT;
>  	}
>  
>  	/* Here comes the firmware version... (hopefully) */
>  	ret = i2c_master_recv(tx->c, buf, 4);
>  	if (ret != 4) {
> -		dev_err(tx->ir->l.dev, "i2c_master_recv failed with %d\n", ret);
> +		ir_err(tx->ir, "i2c_master_recv failed with %d\n", ret);
>  		return 0;
>  	}
>  	if ((buf[0] != 0x80) && (buf[0] != 0xa0)) {
> -		dev_err(tx->ir->l.dev, "unexpected IR TX init response: %02x\n",
> -				       buf[0]);
> +		ir_err(tx->ir, "unexpected IR TX init response: %02x\n",
> +		       buf[0]);
>  		return 0;
>  	}
> -	dev_notice(tx->ir->l.dev, "Zilog/Hauppauge IR blaster firmware version "
> -		     "%d.%d.%d loaded\n", buf[1], buf[2], buf[3]);
> +	ir_notice(tx->ir, "Zilog/Hauppauge IR blaster firmware version %d.%d.%d loaded\n",
> +		  buf[1], buf[2], buf[3]);
>  
>  	return 0;
>  }
> @@ -761,12 +767,12 @@ static int fw_load(struct IR_tx *tx)
>  	/* Request codeset data file */
>  	ret = request_firmware(&fw_entry, "haup-ir-blaster.bin", tx->ir->l.dev);
>  	if (ret != 0) {
> -		dev_err(tx->ir->l.dev, "firmware haup-ir-blaster.bin not available (%d)\n",
> -			    ret);
> +		ir_err(tx->ir, "firmware haup-ir-blaster.bin not available (%d)\n",
> +		       ret);
>  		ret = ret < 0 ? ret : -EFAULT;
>  		goto out;
>  	}
> -	dev_dbg(tx->ir->l.dev, "firmware of size %zu loaded\n", fw_entry->size);
> +	ir_dbg(tx->ir, "firmware of size %zu loaded\n", fw_entry->size);
>  
>  	/* Parse the file */
>  	tx_data = vmalloc(sizeof(*tx_data));
> @@ -794,9 +800,8 @@ static int fw_load(struct IR_tx *tx)
>  	if (!read_uint8(&data, tx_data->endp, &version))
>  		goto corrupt;
>  	if (version != 1) {
> -		dev_err(tx->ir->l.dev, "unsupported code set file version (%u, expected"
> -			    "1) -- please upgrade to a newer driver",
> -			    version);
> +		ir_err(tx->ir, "unsupported code set file version (%u, expected 1) -- please upgrade to a newer driver\n",
> +		       version);
>  		fw_unload_locked();
>  		ret = -EFAULT;
>  		goto out;
> @@ -811,8 +816,8 @@ static int fw_load(struct IR_tx *tx)
>  			      &tx_data->num_code_sets))
>  		goto corrupt;
>  
> -	dev_dbg(tx->ir->l.dev, "%u IR blaster codesets loaded\n",
> -			       tx_data->num_code_sets);
> +	ir_dbg(tx->ir, "%u IR blaster codesets loaded\n",
> +	       tx_data->num_code_sets);
>  
>  	tx_data->code_sets = vmalloc(
>  		tx_data->num_code_sets * sizeof(char *));
> @@ -876,7 +881,7 @@ static int fw_load(struct IR_tx *tx)
>  	goto out;
>  
>  corrupt:
> -	dev_err(tx->ir->l.dev, "firmware is corrupt\n");
> +	ir_err(tx->ir, "firmware is corrupt\n");
>  	fw_unload_locked();
>  	ret = -EFAULT;
>  
> @@ -896,9 +901,8 @@ static ssize_t read(struct file *filep, char __user *outbuf, size_t n,
>  	unsigned int m;
>  	DECLARE_WAITQUEUE(wait, current);
>  
> -	dev_dbg(ir->l.dev, "read called\n");
>  	if (n % rbuf->chunk_size) {
> -		dev_dbg(ir->l.dev, "read result = -EINVAL\n");
> +		ir_dbg(ir, "read result = -EINVAL\n");
>  		return -EINVAL;
>  	}
>  
> @@ -942,8 +946,8 @@ static ssize_t read(struct file *filep, char __user *outbuf, size_t n,
>  			unsigned char buf[MAX_XFER_SIZE];
>  
>  			if (rbuf->chunk_size > sizeof(buf)) {
> -				dev_err(ir->l.dev, "chunk_size is too big (%d)!\n",
> -					    rbuf->chunk_size);
> +				ir_err(ir, "chunk_size is too big (%d)!\n",
> +				       rbuf->chunk_size);
>  				ret = -EINVAL;
>  				break;
>  			}
> @@ -956,7 +960,7 @@ static ssize_t read(struct file *filep, char __user *outbuf, size_t n,
>  				retries++;
>  			}
>  			if (retries >= 5) {
> -				dev_err(ir->l.dev, "Buffer read failed!\n");
> +				ir_err(ir, "Buffer read failed!\n");
>  				ret = -EIO;
>  			}
>  		}
> @@ -966,8 +970,7 @@ static ssize_t read(struct file *filep, char __user *outbuf, size_t n,
>  	put_ir_rx(rx, false);
>  	set_current_state(TASK_RUNNING);
>  
> -	dev_dbg(ir->l.dev, "read result = %d (%s)\n",
> -			   ret, ret ? "Error" : "OK");
> +	ir_dbg(ir, "read result = %d (%s)\n", ret, ret ? "Error" : "OK");
>  
>  	return ret ? ret : written;
>  }
> @@ -983,8 +986,8 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
>  	ret = get_key_data(data_block, code, key);
>  
>  	if (ret == -EPROTO) {
> -		dev_err(tx->ir->l.dev, "failed to get data for code %u, key %u -- check "
> -			    "lircd.conf entries\n", code, key);
> +		ir_err(tx->ir, "failed to get data for code %u, key %u -- check lircd.conf entries\n",
> +		       code, key);
>  		return ret;
>  	} else if (ret != 0)
>  		return ret;
> @@ -999,7 +1002,7 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
>  	buf[1] = 0x40;
>  	ret = i2c_master_send(tx->c, buf, 2);
>  	if (ret != 2) {
> -		dev_err(tx->ir->l.dev, "i2c_master_send failed with %d\n", ret);
> +		ir_err(tx->ir, "i2c_master_send failed with %d\n", ret);
>  		return ret < 0 ? ret : -EFAULT;
>  	}
>  
> @@ -1012,19 +1015,18 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
>  	}
>  
>  	if (ret != 1) {
> -		dev_err(tx->ir->l.dev, "i2c_master_send failed with %d\n", ret);
> +		ir_err(tx->ir, "i2c_master_send failed with %d\n", ret);
>  		return ret < 0 ? ret : -EFAULT;
>  	}
>  
>  	/* Send finished download? */
>  	ret = i2c_master_recv(tx->c, buf, 1);
>  	if (ret != 1) {
> -		dev_err(tx->ir->l.dev, "i2c_master_recv failed with %d\n", ret);
> +		ir_err(tx->ir, "i2c_master_recv failed with %d\n", ret);
>  		return ret < 0 ? ret : -EFAULT;
>  	}
>  	if (buf[0] != 0xA0) {
> -		dev_err(tx->ir->l.dev, "unexpected IR TX response #1: %02x\n",
> -			buf[0]);
> +		ir_err(tx->ir, "unexpected IR TX response #1: %02x\n", buf[0]);
>  		return -EFAULT;
>  	}
>  
> @@ -1033,7 +1035,7 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
>  	buf[1] = 0x80;
>  	ret = i2c_master_send(tx->c, buf, 2);
>  	if (ret != 2) {
> -		dev_err(tx->ir->l.dev, "i2c_master_send failed with %d\n", ret);
> +		ir_err(tx->ir, "i2c_master_send failed with %d\n", ret);
>  		return ret < 0 ? ret : -EFAULT;
>  	}
>  
> @@ -1043,7 +1045,7 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
>  	 * going to skip this whole mess and say we're done on the HD PVR
>  	 */
>  	if (!tx->post_tx_ready_poll) {
> -		dev_dbg(tx->ir->l.dev, "sent code %u, key %u\n", code, key);
> +		ir_dbg(tx->ir, "sent code %u, key %u\n", code, key);
>  		return 0;
>  	}
>  
> @@ -1059,29 +1061,28 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
>  		ret = i2c_master_send(tx->c, buf, 1);
>  		if (ret == 1)
>  			break;
> -		dev_dbg(tx->ir->l.dev, "NAK expected: i2c_master_send "
> -			"failed with %d (try %d)\n", ret, i+1);
> +		ir_dbg(tx->ir, "NAK expected: i2c_master_send failed with %d (try %d)\n",
> +		       ret, i + 1);
>  	}
>  	if (ret != 1) {
> -		dev_err(tx->ir->l.dev, "IR TX chip never got ready: last i2c_master_send "
> -			    "failed with %d\n", ret);
> +		ir_err(tx->ir, "IR TX chip never got ready: last i2c_master_send failed with %d\n",
> +		       ret);
>  		return ret < 0 ? ret : -EFAULT;
>  	}
>  
>  	/* Seems to be an 'ok' response */
>  	i = i2c_master_recv(tx->c, buf, 1);
>  	if (i != 1) {
> -		dev_err(tx->ir->l.dev, "i2c_master_recv failed with %d\n", ret);
> +		ir_err(tx->ir, "i2c_master_recv failed with %d\n", ret);
>  		return -EFAULT;
>  	}
>  	if (buf[0] != 0x80) {
> -		dev_err(tx->ir->l.dev, "unexpected IR TX response #2: %02x\n",
> -				       buf[0]);
> +		ir_err(tx->ir, "unexpected IR TX response #2: %02x\n", buf[0]);
>  		return -EFAULT;
>  	}
>  
>  	/* Oh good, it worked */
> -	dev_dbg(tx->ir->l.dev, "sent code %u, key %u\n", code, key);
> +	ir_dbg(tx->ir, "sent code %u, key %u\n", code, key);
>  	return 0;
>  }
>  
> @@ -1167,12 +1168,10 @@ static ssize_t write(struct file *filep, const char __user *buf, size_t n,
>  		 */
>  		if (ret != 0) {
>  			/* Looks like the chip crashed, reset it */
> -			dev_err(tx->ir->l.dev, "sending to the IR transmitter chip "
> -				    "failed, trying reset\n");
> +			ir_err(tx->ir, "sending to the IR transmitter chip failed, trying reset\n");
>  
>  			if (failures >= 3) {
> -				dev_err(tx->ir->l.dev, "unable to send to the IR chip "
> -					    "after 3 resets, giving up\n");
> +				ir_err(tx->ir, "unable to send to the IR chip after 3 resets, giving up\n");
>  				mutex_unlock(&ir->ir_lock);
>  				mutex_unlock(&tx->client_lock);
>  				put_ir_tx(tx, false);
> @@ -1206,15 +1205,13 @@ static unsigned int poll(struct file *filep, poll_table *wait)
>  	struct lirc_buffer *rbuf = ir->l.rbuf;
>  	unsigned int ret;
>  
> -	dev_dbg(ir->l.dev, "poll called\n");
> -
>  	rx = get_ir_rx(ir);
>  	if (rx == NULL) {
>  		/*
>  		 * Revisit this, if our poll function ever reports writeable
>  		 * status for Tx
>  		 */
> -		dev_dbg(ir->l.dev, "poll result = POLLERR\n");
> +		ir_dbg(ir, "poll result = POLLERR\n");
>  		return POLLERR;
>  	}
>  
> @@ -1227,8 +1224,7 @@ static unsigned int poll(struct file *filep, poll_table *wait)
>  	/* Indicate what ops could happen immediately without blocking */
>  	ret = lirc_buffer_empty(rbuf) ? 0 : (POLLIN|POLLRDNORM);
>  
> -	dev_dbg(ir->l.dev, "poll result = %s\n",
> -			   ret ? "POLLIN|POLLRDNORM" : "none");
> +	ir_dbg(ir, "poll result = %s\n", ret ? "POLLIN|POLLRDNORM" : "none");
>  	return ret;
>  }
>  
> @@ -1335,7 +1331,7 @@ static int close(struct inode *node, struct file *filep)
>  	struct IR *ir = filep->private_data;
>  
>  	if (ir == NULL) {
> -		dev_err(ir->l.dev, "close: no private_data attached to the file!\n");
> +		ir_err(ir, "close: no private_data attached to the file!\n");
>  		return -ENODEV;
>  	}
>  
> @@ -1542,8 +1538,8 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  
>  		/* Proceed only if the Rx client is also ready or not needed */
>  		if (rx == NULL && !tx_only) {
> -			dev_info(tx->ir->l.dev, "probe of IR Tx on %s (i2c-%d) done. Waiting"
> -				   " on IR Rx.\n", adap->name, adap->nr);
> +			ir_info(tx->ir, "probe of IR Tx on %s (i2c-%d) done. Waiting on IR Rx.\n",
> +				adap->name, adap->nr);
>  			goto out_ok;
>  		}
>  	} else {
> @@ -1581,8 +1577,8 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  				       "zilog-rx-i2c-%d", adap->nr);
>  		if (IS_ERR(rx->task)) {
>  			ret = PTR_ERR(rx->task);
> -			dev_err(tx->ir->l.dev, "%s: could not start IR Rx polling thread"
> -				    "\n", __func__);
> +			ir_err(tx->ir, "%s: could not start IR Rx polling thread\n",
> +			       __func__);
>  			/* Failed kthread, so put back the ir ref */
>  			put_ir_device(ir, true);
>  			/* Failure exit, so put back rx ref from i2c_client */
> @@ -1604,13 +1600,13 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  	ir->l.minor = minor; /* module option: user requested minor number */
>  	ir->l.minor = lirc_register_driver(&ir->l);
>  	if (ir->l.minor < 0 || ir->l.minor >= MAX_IRCTL_DEVICES) {
> -		dev_err(tx->ir->l.dev, "%s: \"minor\" must be between 0 and %d (%d)!\n",
> -			    __func__, MAX_IRCTL_DEVICES-1, ir->l.minor);
> +		ir_err(tx->ir, "%s: \"minor\" must be between 0 and %d (%d)!\n",
> +		       __func__, MAX_IRCTL_DEVICES - 1, ir->l.minor);
>  		ret = -EBADRQC;
>  		goto out_put_xx;
>  	}
> -	dev_info(ir->l.dev, "IR unit on %s (i2c-%d) registered as lirc%d and ready\n",
> -		   adap->name, adap->nr, ir->l.minor);
> +	ir_info(ir, "IR unit on %s (i2c-%d) registered as lirc%d and ready\n",
> +		adap->name, adap->nr, ir->l.minor);
>  
>  out_ok:
>  	if (rx != NULL)
> @@ -1618,8 +1614,8 @@ out_ok:
>  	if (tx != NULL)
>  		put_ir_tx(tx, true);
>  	put_ir_device(ir, true);
> -	dev_info(ir->l.dev, "probe of IR %s on %s (i2c-%d) done\n",
> -		   tx_probe ? "Tx" : "Rx", adap->name, adap->nr);
> +	ir_info(ir, "probe of IR %s on %s (i2c-%d) done\n",
> +		tx_probe ? "Tx" : "Rx", adap->name, adap->nr);
>  	mutex_unlock(&ir_devices_lock);
>  	return 0;
>  
> @@ -1632,8 +1628,7 @@ out_put_ir:
>  	put_ir_device(ir, true);
>  out_no_ir:
>  	dev_err(&client->dev, "%s: probing IR %s on %s (i2c-%d) failed with %d\n",
> -		    __func__, tx_probe ? "Tx" : "Rx", adap->name, adap->nr,
> -		   ret);
> +		__func__, tx_probe ? "Tx" : "Rx", adap->name, adap->nr, ret);
>  	mutex_unlock(&ir_devices_lock);
>  	return ret;
>  }
> 
> 
