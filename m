Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab3JYPEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 11:04:43 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:46415 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab3JYPDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:03:47 -0400
Date: Fri, 25 Oct 2013 18:02:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dominik Paulus <dominik.paulus@fau.de>
Cc: Anthony Foiani <anthony.foiani@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kurt Kanzenbach <ly80toro@cip.cs.fau.de>, tobias.polzer@fau.de,
        linux-kernel@vger.kernel.org,
        Ilija Hadzic <ihadzic@research.bell-labs.com>
Subject: Re: [PATCHv4 12/16] staging: usbip: Pass session keys to the kernel
Message-ID: <20131025150251.GH5871@mwanda>
References: <20130930123821.GI6192@mwanda>
 <1382193559-12549-1-git-send-email-dominik.paulus@fau.de>
 <1382193559-12549-13-git-send-email-dominik.paulus@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382193559-12549-13-git-send-email-dominik.paulus@fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 19, 2013 at 04:39:15PM +0200, Dominik Paulus wrote:
> @@ -367,10 +367,17 @@ int usbip_host_export_device(struct usbip_exported_device *edev,
>  		return -1;
>  	}
>  
> -	snprintf(sockfd_buff, sizeof(sockfd_buff), "%d\n", conf->sockfd);
> -	dbg("write: %s", sockfd_buff);
> +	{
> +		char key1[33], key2[33];
> +		snprintf(sockfd_buff, sizeof(sockfd_buff), "%d %d %s %s\n",
> +				conf->sockfd, conf->use_crypto,
> +				keytohex(conf->key2, key2),
> +				keytohex(conf->key1, key1));
> +		dbg("write: %s", sockfd_buff);
> +	}

This is gross.  Don't do that.  My gut says to just delete the debug
code but I hate debug code by default.

> -	ret = sysfs_write_attribute(attr, sockfd_buff, strlen(sockfd_buff));
> +	ret = sysfs_write_attribute(attr, (const char *) sockfd_buff,

Don't put a space between the cast and the variable.

	ret = sysfs_write_attribute(attr, (const char *)sockfd_buff,

regards,
dan carpenter
