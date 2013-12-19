Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab3LSQcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:32:10 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22871 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab3LSQcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:32:08 -0500
Date: Thu, 19 Dec 2013 19:31:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
Cc: linux@rationality.eu, devel@driverdev.osuosl.org,
        linux-kernel@i4.cs.fau.de, tvboxspy@gmail.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        forest@alittletooquiet.net, more.andres@gmail.com
Subject: Re: [PATCH 1/2] vt6656: Make checkpatch happier
Message-ID: <20131219163136.GJ28413@mwanda>
References: <1387466826-2410-1-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
 <1387466826-2410-2-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387466826-2410-2-git-send-email-sebastian.rachuj@studium.uni-erlangen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 04:27:05PM +0100, Sebastian Rachuj wrote:
> From: Simon Schuster <linux@rationality.eu>
> 
> This patch reformats bssdb.c of the vt6656 driver (in staging) to
> conform to the linux coding guidelines.
> 
> The indentation is adjusted to use tabs, the argument lists and
> conditions are aligned to reduce line lengths and preserve
> readability. Curly braces around one-line blocks are removed and
> the C99-style comments are converted to C89-style ones. Previously
> commented code is removed.
> 

Too many changes at once.  This is like an automatic rejection before I
even read the patch.  Sorry.  Each item in this list should be a
separate patch.

> Unfortunately these measures do not satisfy checkpatch completely
> since the code contains too many nested blocks which do not allow to
> keep the lines below 80 characters. Nevertheless the file should be
> more readable after applying this patch.
> 
> Signed-off-by: Sebastian Rachuj <sebastian.rachuj@studium.uni-erlangen.de>
> Signed-off-by: Simon Schuster <linux@rationality.eu>
> ---


> +		if ((!is_broadcast_ether_addr(pbyDesireBSSID))
> +		    && (memcmp(pbyDesireBSSID, ZeroBSSID, 6) != 0))

In the original it was written like this:

		if ((!is_broadcast_ether_addr(pbyDesireBSSID)) &&
		    (memcmp(pbyDesireBSSID, ZeroBSSID, 6) != 0))

That's actually better kernel style to do it that way.  (The original
didn't actually look exactly like I said, it looked like garbage, but
you understand what I mean about the position of the "&&" characters.)

Btw, really it should be:

		if (is_valid_ether_addr(pbyDesireBSSID))

regards,
dan carpenter
