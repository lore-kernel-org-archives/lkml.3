Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbaJXEwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 00:52:35 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:35208 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaJXEwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 00:52:34 -0400
Date: Fri, 24 Oct 2014 07:51:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Eric Rost <eric.rost@mybabylon.net>
Cc: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] staging: skein: Adds CryptoAPI Support
Message-ID: <20141024045154.GS23154@mwanda>
References: <cover.1414102205.git.eric.rost@mybabylon.net>
 <27089a0e5718341c7d1e7c6b21128d8db9237405.1414102205.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27089a0e5718341c7d1e7c6b21128d8db9237405.1414102205.git.eric.rost@mybabylon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First of all this patch does too many things at once.  Collapsing files
and deleting them needs to be done in separate patches from adding them.
There is the "one thing per patch" and each one of those is a separate
thing.

On Thu, Oct 23, 2014 at 05:12:10PM -0500, Eric Rost wrote:
> +int skein256_update(struct shash_desc *desc, const u8 *data,
> +			unsigned int len)
> +{
> +	return skein_256_update((struct skein_256_ctx *) shash_desc_ctx(desc),
> +			data, (size_t) len);
> +}

The two line version of this cast was prettier.  Also if you run
checkpatch.pl --strict over this it will hopefully warn about the
space in the middle of the cast and the alignment of data.  Also the
cast to size_t is superflous.

The checkpatch --strict version of this looks like:

int skein256_update(struct shash_desc *desc, const u8 *data,
			unsigned int len)
{
	return skein_256_update((struct skein_256_ctx *)shash_desc_ctx(desc),
				data, len);
}

Eventually, I feel like we would wave skein_256_update() to just take
a shash_desc pointer?  We'd have to shuffle the skein_ctx struct a bit
to make that work.  (I haven't looked at this carefully).

regards,
dan carpenter

