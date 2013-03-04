Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab3CDTxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 14:53:42 -0500
Received: from mout.gmx.net ([212.227.17.21]:62339 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758295Ab3CDTxl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 14:53:41 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+UwGVBvlyUaMbaJwv1c2o/gCws/qn+SIXbo1Zwu8
	Dm5s7U+87da1nz
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: tpmdd-devel@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH v2] tpm: Add support for new Infineon I2C TPM (SLB 9645 TT 1.2 I2C)
Date: Mon, 4 Mar 2013 20:54:16 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.7; KDE/4.9.5; x86_64; ; )
Cc: Kent Yoder <key@linux.vnet.ibm.com>,
        Peter Huewe <peter.huewe@infineon.com>,
        linux-security-module@vger.kernel.org, shpedoikal@gmail.com,
        linux-kernel@vger.kernel.org
References: <1362408106-8632-1-git-send-email-peter.huewe@infineon.com> <20130304174104.GA10811@ennui.austin.ibm.com>
In-Reply-To: <20130304174104.GA10811@ennui.austin.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201303042054.16849.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kent,

short reply from my private account - so only talking on behalf of myself.

Am Montag, 4. März 2013, 18:41:04 schrieb Kent Yoder:
> Hi Peter,
> 
>   Sorry for the long delay in getting this reviewed...
No problem.

> 
> > -	for (count = 0; count < MAX_COUNT; count++) {
> > -		usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
> > -		rc = __i2c_transfer(tpm_dev.client->adapter, &msg2, 1);
> > -		if (rc > 0)
> > -			break;
> > +	if (tpm_dev.chip_type == SLB9645) {
> > +		/* use a combined read for newer chips
> > +		 * unfortunately the smbus functions are not suitable due to
> > +		 * the 32 byte limit of the smbus.
> > +		 * retries should usually not be needed, but are kept just to
> > +		 * be on the safe side.
> > +		*/
> 
>   Bump out that last line of comment by a column.

You mean I should add 1 space - okay, no problem.
(and I'm nitty picky.... ;) *g*


> > 
> >  	if (rc <= 0)
> >  	
> >  		return -EIO;
> 
>  This confused me for a second, but I see __i2c_transfer returns the number
> of messages transferred. Maybe worth adding a comment.

Maybe I can add one - I'll think about it.


> > 
> > +
> > +#ifdef CONFIG_OF
> > +static const struct of_device_id tpm_tis_i2c_of_match[] = {
> > +	{ .compatible = "infineon,tpm_i2c_infineon", .data = (void *)0 },
> > +	{ .compatible = "infineon,slb9635tt", .data = (void *)0 },
> > +	{ .compatible = "infineon,slb9645tt", .data = (void *)1 },
> 
>   Here "name" and "type" are left empty in of_device_id. Will there be
> times when those are needed? Like informational messages from the OF
> subsystem?

Hmm, what do you propose?
name = chip type ? or name = tpm_i2c_infineon?
type = tpm ?



> > 
> > +		   .of_match_table = of_match_ptr(tpm_tis_i2c_of_match),
> 
>   Please put this line inside an ifdef CONFIG_OF, since of_match_ptr
> lives in there.
NACK.
of.h has already the ifdef CONFIG_OF for of_match_ptr and defines it either as 

#define of_match_ptr(_ptr)      (_ptr)
or
#define of_match_ptr(_ptr)      NULL
depending on CONFIG_OF is set.



>   Won't you also need to add OF to Kconfig?
Not really, as the only stuff we're using is the compatible id - the driver can 
live without it and can be probed from userspace or plain old platform data.
I probably have compile tested it with and without CONFIG_OF.


Is it worth a v3?
 or a small update patch which adds the of name/type and the space? (I can 
create this patch immediately)


Thanks,
Peter



