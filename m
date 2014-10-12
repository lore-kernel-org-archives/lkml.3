Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbaJLCLa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 22:11:30 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:60689 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbaJLCL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 22:11:29 -0400
Date: Sat, 11 Oct 2014 19:11:22 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mark D Rustad <mrustad@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, Torsten Duwe <duwe@lst.de>,
        "Theodore Ts'o" <tytso@mit.edu>, Jason Cooper <jason@lakedaemon.net>,
        Amit Shah <amit.shah@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] char: hw_random: core.c:  Changed from using strncpy to
 strlcpy
Message-ID: <20141012021122.GA10822@roeck-us.net>
References: <1413067004-10925-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <09FC08CC-027E-443A-83C3-CC4C1D978743@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09FC08CC-027E-443A-83C3-CC4C1D978743@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 05:27:41PM -0700, Mark D Rustad wrote:
> On Oct 11, 2014, at 3:36 PM, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:
> 
> > Changed from using strncpy to strlcpy to simplify the code
> 
> Actually you changed from using strncat to strlcat.
> 
... and changed the length parameter along the way, making the length check
overall quite worthless and introducing a _real_ problem.

Guenter

> > Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> > ---
> > drivers/char/hw_random/core.c |   12 ++++--------
> > 1 file changed, 4 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> > index aa30a25..1500cfd 100644
> > --- a/drivers/char/hw_random/core.c
> > +++ b/drivers/char/hw_random/core.c
> > @@ -281,7 +281,6 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
> > 					 char *buf)
> > {
> > 	int err;
> > -	ssize_t ret = 0;
> > 	struct hwrng *rng;
> > 
> > 	err = mutex_lock_interruptible(&rng_mutex);
> > @@ -289,16 +288,13 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
> > 		return -ERESTARTSYS;
> > 	buf[0] = '\0';
> > 	list_for_each_entry(rng, &rng_list, list) {
> > -		strncat(buf, rng->name, PAGE_SIZE - ret - 1);
> > -		ret += strlen(rng->name);
> > -		strncat(buf, " ", PAGE_SIZE - ret - 1);
> > -		ret++;
> > +		strlcat(buf, rng->name, PAGE_SIZE);
> > +		strlcat(buf, " ", PAGE_SIZE);
> > 	}
> > -	strncat(buf, "\n", PAGE_SIZE - ret - 1);
> > -	ret++;
> > +	strlcat(buf, "\n", PAGE_SIZE);
> > 	mutex_unlock(&rng_mutex);
> > 
> > -	return ret;
> > +	return strlen(buf);
> > }
> > 
> > static DEVICE_ATTR(rng_current, S_IRUGO | S_IWUSR,
> > -- 
> > 1.7.10.4
> 
> -- 
> Mark Rustad, MRustad@gmail.com
> 


