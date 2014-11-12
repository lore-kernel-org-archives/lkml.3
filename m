Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaKLVSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 16:18:39 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:25649 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbaKLVSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 16:18:36 -0500
Date: Thu, 13 Nov 2014 00:18:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, trivial@kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH v2 1/2] staging: rtl8188eu: Deletion of unnecessary
 checks before three function calls
Message-ID: <20141112211815.GJ6749@mwanda>
References: <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <544954FD.8040607@users.sourceforge.net>
 <20141029084702.GA18675@kroah.com>
 <5453CD0D.9010206@users.sourceforge.net>
 <alpine.DEB.2.10.1410311900201.2481@hadrien>
 <5463C10D.6020409@users.sourceforge.net>
 <5463C22B.7060405@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5463C22B.7060405@users.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 09:25:15PM +0100, SF Markus Elfring wrote:
> @@ -487,8 +488,7 @@ static void rtw_usb_if1_deinit(struct adapter *if1)
>  	DBG_88E("+r871xu_dev_remove, hw_init_completed=%d\n",
>  		if1->hw_init_completed);
>  	rtw_free_drv_sw(if1);
> -	if (pnetdev)
> -		rtw_free_netdev(pnetdev);
> +	rtw_free_netdev(pnetdev);

I still feel that hiding the if statement inside the function call makes
the code more subtle and it is a bad harmful thing to do.  This is
especially true if you have trained yourself to know that free_netdev()
can't accept NULL pointers.

regards,
dan carpenter

