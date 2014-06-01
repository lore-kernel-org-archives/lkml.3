Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbaFANf2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 09:35:28 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40292 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757099AbaFANfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 09:35:24 -0400
Date: Sun, 1 Jun 2014 16:34:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: walter harms <wharms@bfs.de>
Cc: Peter Senna Tschudin <peter.senna@gmail.com>,
        Samuel Ortiz <samuel@sortiz.org>, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/11] via-ircc: Remove useless return variables
Message-ID: <20140601133421.GQ15585@mwanda>
References: <1401542051-3174-4-git-send-email-peter.senna@gmail.com>
 <20140531203658.GO15585@mwanda>
 <538B11A6.30306@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538B11A6.30306@bfs.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2014 at 01:42:30PM +0200, walter harms wrote:
> >>  static int via_ircc_read_dongle_id(int iobase)
> >> -{
> >> -	int dongle_id = 9;	/* Default to IBM */
> >> -
> >> +{/* Default to IBM */
> > 
> > Yuck.  And anyway, the comment should be on return line.  (And of course
> > there should have been a #define IBM_DONGLE_ID 9, but that's probably
> > something for another patch.
> > 
> >>  	IRDA_ERROR("via-ircc: dongle probing not supported, please specify dongle_id module parameter.\n");
> >> -	return dongle_id;
> >> +	return 9;
> 
> 
> more over code and error msg do not fit,
> it returns a default of 9 (what ever that means) it does not look like
> an error. Sow the warning should be
> 
> via-ircc: dongle probing not supported, please specify dongle_id module parameter. settting dongle_id=9
>

The print is ok.  It's called like this:

   328          /* Check if user has supplied the dongle id or not */
   329          if (!dongle_id)
   330                  dongle_id = via_ircc_read_dongle_id(self->io.fir_base);
   331          self->io.dongle_id = dongle_id;

If you don't use a module id then it acts like an IBM dongle by default.

regards,
dan carpenter

