Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaIALtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:49:50 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:53883 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaIALts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:49:48 -0400
Date: Mon, 1 Sep 2014 17:19:35 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com
Subject: Re: [PATCH] staging: goldfish_audio.c: sparse warning of incorrect
 type
Message-ID: <20140901114935.GA8617@sudip-PC>
References: <1409501782-20775-1-git-send-email-sudipm.mukherjee@gmail.com>
 <20140901093514.GE5122@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140901093514.GE5122@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 12:35:14PM +0300, Dan Carpenter wrote:
> On Sun, Aug 31, 2014 at 09:46:22PM +0530, Sudip Mukherjee wrote:
> > @@ -133,9 +134,15 @@ static ssize_t goldfish_audio_read(struct file *fp, char __user *buf,
> >  						AUDIO_READ_BUFFER_AVAILABLE);
> >  
> >  		/* copy data to user space */
> > -		if (copy_to_user(buf, data->read_buffer, length))
> > +		buffer = kzalloc(length, GFP_KERNEL);
> > +		if (buffer == NULL)
> > +			return -ENOMEM;
> > +		memcpy_fromio(buffer, data->read_buffer, length);
> > +		if (copy_to_user((void __user *)buf, buffer, length)) {
>                                  ^^^^^^^^^^^^^^^
> This cast shouldn't be needed.
> 
> regards,
> dan carpenter
> 

yes , its not needed . I just checked it again after removing the cast. Actually I gave it as sparse was showing warning for argument 1 also. I should have rechecked it after fixing the warning for argument2. Sorry for it.
Anyways, if Alan confirms that this patch is actually needed then I will resubmit a modified patch.

thanks
Sudip
