Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbaJBIOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 04:14:15 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40145 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaJBIOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 04:14:11 -0400
Date: Thu, 2 Oct 2014 11:13:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Amber Thrall <amber.rose.thrall@gmail.com>
Cc: greg@kroah.com, jarod@wilsonet.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] Fixed all coding style issues for
 drivers/staging/media/lirc/
Message-ID: <20141002081353.GG5865@mwanda>
References: <1412217351-27091-1-git-send-email-amber.rose.thrall@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412217351-27091-1-git-send-email-amber.rose.thrall@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 07:35:51PM -0700, Amber Thrall wrote:
> Fixed various coding sytles.
> 

Fix one type of thing at a time.

> Signed-off-by: Amber Thrall <amber.rose.thrall@gmail.com>
> ---
>  drivers/staging/media/lirc/lirc_bt829.c  |  2 +-
>  drivers/staging/media/lirc/lirc_imon.c   |  4 +-
>  drivers/staging/media/lirc/lirc_sasem.c  |  6 +--
>  drivers/staging/media/lirc/lirc_serial.c | 29 ++++++--------
>  drivers/staging/media/lirc/lirc_sir.c    |  3 +-
>  drivers/staging/media/lirc/lirc_zilog.c  | 69 +++++++++++++++-----------------
>  6 files changed, 52 insertions(+), 61 deletions(-)
> 
> diff --git a/drivers/staging/media/lirc/lirc_bt829.c b/drivers/staging/media/lirc/lirc_bt829.c
> index 4c806ba..c70ca68 100644
> --- a/drivers/staging/media/lirc/lirc_bt829.c
> +++ b/drivers/staging/media/lirc/lirc_bt829.c
> @@ -59,7 +59,7 @@ static bool debug;
>  #define dprintk(fmt, args...)						 \
>  	do {								 \
>  		if (debug)						 \
> -			printk(KERN_DEBUG DRIVER_NAME ": "fmt, ## args); \
> +			dev_dbg(DRIVER_NAME, ": "fmt, ##args); \

I think we need to pass a dev pointer to the dev_dbg() functions.  Does
this even compile?  I can't test it myself at this minute.

My guess is the reason this compiles is because dprintk() is #ifdefed
out of the actual code.

>  	} while (0)
>  
>  static int atir_minor;
> diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
> index 7aca44f..bce0408 100644
> --- a/drivers/staging/media/lirc/lirc_imon.c
> +++ b/drivers/staging/media/lirc/lirc_imon.c
> @@ -623,8 +623,8 @@ static void imon_incoming_packet(struct imon_context *context,
>  	if (debug) {
>  		dev_info(dev, "raw packet: ");
>  		for (i = 0; i < len; ++i)
> -			printk("%02x ", buf[i]);
> -		printk("\n");
> +			dev_info(dev, "%02x ", buf[i]);
> +		dev_info(dev, "\n");

This doesn't work.  The dev_ functions can't really be split across more
than one line.  The try to put stuff at the start of the line but
we're putting it all on the same line they're putting a bunch of garbage
in the middle of the line.

>  	}
>  
>  	/*
> diff --git a/drivers/staging/media/lirc/lirc_sasem.c b/drivers/staging/media/lirc/lirc_sasem.c
> index c20ef56..e88e246 100644
> --- a/drivers/staging/media/lirc/lirc_sasem.c
> +++ b/drivers/staging/media/lirc/lirc_sasem.c
> @@ -583,10 +583,10 @@ static void incoming_packet(struct sasem_context *context,
>  	}
>  
>  	if (debug) {
> -		printk(KERN_INFO "Incoming data: ");
> +		pr_info("Incoming data: ");
>  		for (i = 0; i < 8; ++i)
> -			printk(KERN_CONT "%02x ", buf[i]);
> -		printk(KERN_CONT "\n");
> +			pr_cont("%02x", buf[i]);
> +		pr_cont("\n");

The debug variable really isn't needed if we're going to use the
standard debugging printks.

>  	}
>  
>  	/*
> diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
> index 181b92b..b07671b 100644
> --- a/drivers/staging/media/lirc/lirc_serial.c
> +++ b/drivers/staging/media/lirc/lirc_serial.c
> @@ -116,8 +116,7 @@ static bool txsense;	/* 0 = active high, 1 = active low */
>  #define dprintk(fmt, args...)					\
>  	do {							\
>  		if (debug)					\
> -			printk(KERN_DEBUG LIRC_DRIVER_NAME ": "	\
> -			       fmt, ## args);			\
> +			dev_dbg(LIRC_DRIVER_NAME, ": "fmt, ##args); \
>  	} while (0)
>  
>  /* forward declarations */
> @@ -356,9 +355,8 @@ static int init_timing_params(unsigned int new_duty_cycle,
>  	/* Derive pulse and space from the period */
>  	pulse_width = period * duty_cycle / 100;
>  	space_width = period - pulse_width;
> -	dprintk("in init_timing_params, freq=%d, duty_cycle=%d, "
> -		"clk/jiffy=%ld, pulse=%ld, space=%ld, "
> -		"conv_us_to_clocks=%ld\n",
> +	dprintk("in init_timing_params, freq=%d, duty_cycle=%d, clk/jiffy=%ld,
> +			pulse=%ld, space=%ld, conv_us_to_clocks=%ld\n",
>  		freq, duty_cycle, __this_cpu_read(cpu_info.loops_per_jiffy),
>  		pulse_width, space_width, conv_us_to_clocks);
>  	return 0;
> @@ -1075,7 +1073,7 @@ static int __init lirc_serial_init(void)
>  
>  	result = platform_driver_register(&lirc_serial_driver);
>  	if (result) {
> -		printk("lirc register returned %d\n", result);
> +		dprintk("lirc register returned %d\n", result);

Check to see what printks platform_driver_register() will print on
failure.  People add printks all over the place out of helpfulness but
a lot of the time they aren't needed.

>  		goto exit_buffer_free;
>  	}
>  
> @@ -1166,22 +1164,20 @@ module_init(lirc_serial_init_module);
>  module_exit(lirc_serial_exit_module);
>  
>  MODULE_DESCRIPTION("Infra-red receiver driver for serial ports.");
> -MODULE_AUTHOR("Ralph Metzler, Trent Piepho, Ben Pfaff, "
> -	      "Christoph Bartelmus, Andrei Tanas");
> +MODULE_AUTHOR("Ralph Metzler, Trent Piepho, Ben Pfaff, Christoph Bartelmus, Andrei Tanas");
>  MODULE_LICENSE("GPL");
>  
>  module_param(type, int, S_IRUGO);
> -MODULE_PARM_DESC(type, "Hardware type (0 = home-brew, 1 = IRdeo,"
> -		 " 2 = IRdeo Remote, 3 = AnimaX, 4 = IgorPlug,"
> -		 " 5 = NSLU2 RX:CTS2/TX:GreenLED)");
> +MODULE_PARM_DESC(type, "Hardware type (0 = home-brew, 1 = IRdeo,
> +	2 = IRdeo Remote, 3 = AnimaX, 4 = IgorPlug,
> +	5 = NSLU2 RX:CTS2/TX:GreenLED)");

The formatting is messed up now.

>  
>  module_param(io, int, S_IRUGO);
>  MODULE_PARM_DESC(io, "I/O address base (0x3f8 or 0x2f8)");
>  
>  /* some architectures (e.g. intel xscale) have memory mapped registers */
>  module_param(iommap, bool, S_IRUGO);
> -MODULE_PARM_DESC(iommap, "physical base for memory mapped I/O"
> -		" (0 = no memory mapped io)");
> +MODULE_PARM_DESC(iommap, "physical base for memory mapped I/O (0 = no memory mapped io)");
>  
>  /*
>   * some architectures (e.g. intel xscale) align the 8bit serial registers
> @@ -1198,13 +1194,12 @@ module_param(share_irq, bool, S_IRUGO);
>  MODULE_PARM_DESC(share_irq, "Share interrupts (0 = off, 1 = on)");
>  
>  module_param(sense, int, S_IRUGO);
> -MODULE_PARM_DESC(sense, "Override autodetection of IR receiver circuit"
> -		 " (0 = active high, 1 = active low )");
> +MODULE_PARM_DESC(sense, "Override autodetection of IR receiver circuit
> +		(0 = active high, 1 = active low )");

This messes up the formatting.

>  
>  #ifdef CONFIG_LIRC_SERIAL_TRANSMITTER
>  module_param(txsense, bool, S_IRUGO);
> -MODULE_PARM_DESC(txsense, "Sense of transmitter circuit"
> -		 " (0 = active high, 1 = active low )");
> +MODULE_PARM_DESC(txsense, "Sense of transmitter circuit (0 = active high, 1 = active low )");
>  #endif
>  
>  module_param(softcarrier, bool, S_IRUGO);
> diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
> index 2ee55ea..cdbb71f 100644
> --- a/drivers/staging/media/lirc/lirc_sir.c
> +++ b/drivers/staging/media/lirc/lirc_sir.c
> @@ -143,8 +143,7 @@ static bool debug;
>  #define dprintk(fmt, args...)						\
>  	do {								\
>  		if (debug)						\
> -			printk(KERN_DEBUG LIRC_DRIVER_NAME ": "		\
> -				fmt, ## args);				\
> +			dev_dbg(LIRC_DRIVER_NAME, ": "fmt, ## args); \
>  	} while (0)
>  
>  /* SECTION: Prototypes */
> diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
> index 567feba..9c3a3d7 100644
> --- a/drivers/staging/media/lirc/lirc_zilog.c
> +++ b/drivers/staging/media/lirc/lirc_zilog.c
> @@ -152,10 +152,9 @@ struct tx_data_struct {
>  static struct tx_data_struct *tx_data;
>  static struct mutex tx_data_lock;
>  
> -#define zilog_notify(s, args...) printk(KERN_NOTICE KBUILD_MODNAME ": " s, \
> -					## args)
> -#define zilog_error(s, args...) printk(KERN_ERR KBUILD_MODNAME ": " s, ## args)
> -#define zilog_info(s, args...) printk(KERN_INFO KBUILD_MODNAME ": " s, ## args)
> +#define zilog_notify(s, args...) dev_notice(KBUILD_MODNAME, ": " s, ## args)
> +#define zilog_error(s, args...) dev_err(KBUILD_MODNAME, ": " s, ## args)
> +#define zilog_info(s, args...) dev_info(KBUILD_MODNAME, ": " s, ## args)

These defines are rubbish and pointless.  Just delete them all.

>  
>  /* module parameters */
>  static bool debug;	/* debug output */
> @@ -165,8 +164,7 @@ static int minor = -1;	/* minor number */
>  #define dprintk(fmt, args...)						\
>  	do {								\
>  		if (debug)						\
> -			printk(KERN_DEBUG KBUILD_MODNAME ": " fmt,	\
> -				 ## args);				\
> +			pr_dbg(KBUILD_MODNAME, ": " fmt, ## args); \
>  	} while (0)
>  
>  
> @@ -382,14 +380,14 @@ static int add_to_buf(struct IR *ir)
>  			zilog_error("i2c_master_send failed with %d\n",	ret);
>  			if (failures >= 3) {
>  				mutex_unlock(&ir->ir_lock);
> -				zilog_error("unable to read from the IR chip "
> -					    "after 3 resets, giving up\n");
> +				zilog_error("unable to read from the IR chip
> +						after 3 resets, giving up\n");


Formatting messed up for everything else beyond this point.  We don't
want to print all those tabs in dmesg.

regards,
dan carpenter

