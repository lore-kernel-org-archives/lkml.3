Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbbAEOAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:00:36 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21268 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbbAEOAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:00:33 -0500
Date: Mon, 5 Jan 2015 16:58:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Jaroslav Kysela <perex@perex.cz>,
        Johannes Berg <johannes@sipsolutions.net>,
        Clemens Ladisch <clemens@ladisch.de>,
        Russell King <linux@arm.linux.org.uk>, Takashi Iwai <tiwai@suse.de>,
        Thibaut Varene <T-Bone@parisc-linux.org>, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org, linux-parisc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 11/13] ALSA: Deletion of checks before the function call
 "iounmap"
Message-ID: <20150105135821.GD15033@mwanda>
References: <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <54A9355F.4050102@users.sourceforge.net>
 <54A941C1.4020906@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A941C1.4020906@users.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2015 at 02:36:01PM +0100, SF Markus Elfring wrote:
>  	/* unmap PCI memory space, mapped during device init. */
> -	for (idx = 0; idx < HPI_MAX_ADAPTER_MEM_SPACES; idx++) {
> -		if (pci.ap_mem_base[idx])
> -			iounmap(pci.ap_mem_base[idx]);
> -	}
> +	for (idx = 0; idx < HPI_MAX_ADAPTER_MEM_SPACES; ++idx)
> +		iounmap(pci.ap_mem_base[idx]);
>  

Don't do the gratuitous idx++ to ++idx changes.  You do it a couple
other places as well.  It belongs in a separate patch if you really feel
it is worth doing.  (It is not a clean up and it is not worth doing).

regards,
dan carpenter

