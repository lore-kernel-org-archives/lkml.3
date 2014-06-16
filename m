Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbaFPH4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 03:56:11 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20710 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaFPH4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 03:56:09 -0400
Date: Mon, 16 Jun 2014 10:55:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Martin Kepplinger <martink@posteo.de>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        forest@alittletooquiet.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6655: preserve address space by not casting
Message-ID: <20140616075556.GZ5500@mwanda>
References: <1402654311-22053-1-git-send-email-martink@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402654311-22053-1-git-send-email-martink@posteo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 12:11:51PM +0200, Martin Kepplinger wrote:
> Fix the sparse error: cast removes address space of expression.
> ---
> Is that even correct?

It's correct but not complete.

vt6655 impliment their own versions of ethtool_ioctl() when they should
be using the standard versions.

The vt6655 version of ethtool_ioctl() should be annotated so it's marked
that the second parameter is marked as a __user pointer.  It doesn't
print a Sparse warning because at a certain point Sparse just says:
"warning: too many warnings" and gives up.

> I haven't signed-off on it yet.
> ethtool_ioctl() takes a (void *) as user data, dereferenced and assigend to u32.
> applies to next-20140611

It doesn't dereference the pointer.  You are getting mixed up with the
vt6656 version of ethtool_ioctl() I think?  You're not allowed to
dereference __user pointers.

regards,
dan carpenter

