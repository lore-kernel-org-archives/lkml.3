Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab3FFVZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:25:07 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43153 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab3FFVZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:25:04 -0400
Date: Fri, 7 Jun 2013 00:23:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Schilling <of82ecuq@cip.cs.fau.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Kurt Kanzenbach <shifty91@gmail.com>, linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Cho <acho@novell.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Laura Lawniczak <laura.lawniczak@googlemail.com>
Subject: Re: [PATCH 5/6] keucr: moved function to other file
Message-ID: <20130606212346.GE28112@mwanda>
References: <20130605094517.GS28112@mwanda>
 <1370535050-7167-1-git-send-email-of82ecuq@cip.cs.fau.de>
 <1370535050-7167-6-git-send-email-of82ecuq@cip.cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370535050-7167-6-git-send-email-of82ecuq@cip.cs.fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 06:10:49PM +0200, Johannes Schilling wrote:
> From: Laura Lawniczak <laura.lawniczak@googlemail.com>
> 
> Function usb_stor_print_cmd was declared in init.c but only used
> in transport.c. So it was reasonable to move it there and declare
> it static
> 
> Signed-off-by: Laura Lawniczak <laura.lawniczak@googlemail.com>

Don't forget your Signed-off-by, Johannes, since it's coming from
you.  Can you resend this?

There are a couple small changes between the original and the moved
function.
1) "blen = 0" is removed from the last line.  This doesn't cause a
   bug.  In a later patch you can remove the "bn = 0" as well.
2) A comma was deleted after the string in the commented code so it
   now has a syntax error:

> +		/*  dev_dbg(
> +			    &us->pusb_dev->dev, "scsi cmd %X --- SCSIOP_READ,bn = %X, blen = %X\n"
> +			    cmd, bn, blen); */

It's better if you just do a straight move and change things in a
later patch.  But for now it's fine.

regards,
dan carpenter

