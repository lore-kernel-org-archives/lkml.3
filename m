Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab3JYN1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:27:34 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26249 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab3JYN1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:27:33 -0400
Date: Fri, 25 Oct 2013 16:26:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dominik Paulus <dominik.paulus@fau.de>
Cc: Anthony Foiani <anthony.foiani@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kurt Kanzenbach <ly80toro@cip.cs.fau.de>, tobias.polzer@fau.de,
        linux-kernel@vger.kernel.org,
        Ilija Hadzic <ihadzic@research.bell-labs.com>
Subject: Re: [PATCHv4 06/16] staging: usbip: Add proper error reporting
Message-ID: <20131025132615.GF5871@mwanda>
References: <20130930123821.GI6192@mwanda>
 <1382193559-12549-1-git-send-email-dominik.paulus@fau.de>
 <1382193559-12549-7-git-send-email-dominik.paulus@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382193559-12549-7-git-send-email-dominik.paulus@fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 19, 2013 at 04:39:09PM +0200, Dominik Paulus wrote:
> +const char *usbip_net_strerror(int status)
> +{
> +	static const char *const errs[] = {
> +		/* ERR_OK */ "Success",
> +		/* ERR_NA */ "Command failed",
> +		/* ERR_MISMATCH */ "Protocol version mismatch",
> +		/* ERR_SYSERR */ "System error",
> +		/* ERR_UNEXPECTED */ "Unexpected opcode received",
> +		/* ERR_AUTHREQ */ "Server requires authentication",
> +		/* ERR_PERM */ "Permission denied",
> +		/* ERR_NOTFOUND */ "Requested device not found",
> +		/* ERR_NOAUTH */ "Server doesn't support authentication"
> +	};
> +	if (status < 0)
> +		status = -status;
> +	if (status >= (int) (sizeof(errs) / sizeof(*errs)))

Not a big deal, but for future reference, the cast here is unneeded.

> +		return "Invalid";
> +	return errs[status];
>  }

