Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844AbaDKJY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 05:24:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37224 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756576AbaDKJV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 05:21:59 -0400
Date: Fri, 11 Apr 2014 11:21:56 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Richard Leitner <me@g0hl1n.net>
Cc: r.marek@assembler.cz, wsa@the-dreams.de, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: busses: ali1563: fix checkpatch.pl issues
Message-ID: <20140411112156.5e7e32c2@endymion.delvare>
In-Reply-To: <1397150924-7260-1-git-send-email-me@g0hl1n.net>
References: <1397150924-7260-1-git-send-email-me@g0hl1n.net>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Thu, 10 Apr 2014 19:28:44 +0200, Richard Leitner wrote:
> Fixed most checkpatch.pl issues

Thanks for doing this. Overall it looks good, there are just two
warnings I would like fixed slightly differently:

> @@ -268,13 +272,14 @@ static s32 ali1563_access(struct i2c_adapter * a, u16 addr,
>  	}
>  
>  	outb_p(((addr & 0x7f) << 1) | (rw & 0x01), SMB_HST_ADD);
> -	outb_p((inb_p(SMB_HST_CNTL2) & ~HST_CNTL2_SIZEMASK) | (size << 3), SMB_HST_CNTL2);
> +	outb_p((inb_p(SMB_HST_CNTL2) & ~HST_CNTL2_SIZEMASK) |
> +			(size << 3), SMB_HST_CNTL2);

Please align on the opening parenthesis.

> @@ -392,14 +398,15 @@ static struct i2c_adapter ali1563_adapter = {
>  static int ali1563_probe(struct pci_dev *dev,
>  			 const struct pci_device_id *id_table)
>  {
> -	int error;
> +	int error = ali1563_setup(dev);
>  
> -	if ((error = ali1563_setup(dev)))
> +	if (error)
>  		goto exit;

Please leave the variable declaration alone, so that the error check
can immediately follow the assignment, as was the case before. Anyway
it is not recommended to run "real code" during variable declaration.

With these changes applied, feel free to add:

Reviewed-by: Jean Delvare <jdelvare@suse.de>

Thanks,
-- 
Jean Delvare
SUSE L3 Support
