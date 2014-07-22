Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbaGVHrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:47:41 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40760 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbaGVHrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:47:40 -0400
Date: Tue, 22 Jul 2014 10:47:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net, dcb314@hotmail.com,
        jason.wessel@windriver.com
Subject: Re: [PATCH 4/5] kernel/debug/kdb/kdb_bp.c: drop negativity check on
 unsigned value
Message-ID: <20140722074721.GM25880@mwanda>
References: <1405697692-23816-1-git-send-email-andrey.krieger.utkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405697692-23816-1-git-send-email-andrey.krieger.utkin@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 06:34:52PM +0300, Andrey Utkin wrote:
>  static char *kdb_bptype(kdb_bp_t *bp)
>  {
> -	if (bp->bp_type < 0 || bp->bp_type > 4)
> +	if (bp->bp_type > 4)
>  		return "";

With Smatch, I ignore negative checks in this format.  It's obvious what
the intent is and they are harmless.  Patching them requires a little
review to make sure that someone isn't introducing a bug and can't be
done directly in the email client.

On the other hand, in Smatch I do complain about checks like:

	if (bp->bp_type > 4 || bp->bp_type < 0)

Because only backwards thinking people write checks like that.

regards,
dan carpenter

