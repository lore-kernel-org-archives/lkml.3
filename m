Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbaEDBN4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 21:13:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbaEDBNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 21:13:55 -0400
Date: Sat, 3 May 2014 20:24:14 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: devel@driverdev.osuosl.org, mcgrof@do-not-panic.com,
        linux-kernel@vger.kernel.org, oat.elena@gmail.com,
        dan.carpenter@oracle.com, Larry.Finger@lwfinger.net
Subject: Re: [PATCH v2] staging: rtl8188eu: fix potential leak in
 rtw_set_key()
Message-ID: <20140504002414.GA10375@kroah.com>
References: <20140501123057.5f00e30d@spike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140501123057.5f00e30d@spike>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 12:30:57PM +0200, Christian Engelmayer wrote:
> Fix a potential leak in the error path of rtw_set_key(). In case the requested
> algorithm is not supported by the driver, the function returns without
> enqueuing or freeing the already allocated command and parameter structs. Use
> a centralized exit path and make sure that all memory is freed correctly.
> Detected by Coverity - CID 1077716, 1077717.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: Added changes requested by Dan Carpenter:
> 
>    * Just return directly where no cleanup is needed.
>    * Prefer naming labels by the labeled action rather than the goto location.
> 
> Compile tested and applies against branch staging-next of tree
> git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git

This patch doesn't apply to my tree, can you refresh and resend it?

thanks,

greg k-h
