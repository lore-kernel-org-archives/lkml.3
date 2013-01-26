Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab3AZUfT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 15:35:19 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40058 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab3AZUfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 15:35:17 -0500
Date: Sat, 26 Jan 2013 23:35:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jake Champlin <jake.champlin.27@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: csr: csr_msgconv: Fixed Multiple Coding Style
 Issues
Message-ID: <20130126203512.GD4584@mwanda>
References: <20130126201431.GA18436@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130126201431.GA18436@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2013 at 03:14:35PM -0500, Jake Champlin wrote:
> Resolved 150 Style Errors and 202 Coding Style Warnings.
> 

Normally we would prefer that these are broken up into a several
different patches that each fix one type of style issue.

[patch 1/x] csr: csr_msgconv: use tab indents
[patch 2/x] csr: csr_msgconv: put curly braces on the right line
etc...

> +	CsrMsgConvPrimEntry *ptr = NULL;
> +
> +	if (converter) {
> +		ptr = converter->profile_converters;
> +	while (ptr) {
> +		if (ptr->primType == primType)
> +			break;
> +		else
> +			ptr = ptr->next;
> +	}
> +	}

The while loop should be indented one more time.

> +	if (ptr) {
> +		const CsrMsgConvMsgEntry *cv;
> +		u16 msgId = 0;
> +		size_t offset = 0;
> +		CsrUint16Des(&msgId, data, &offset);
> +
> +		cv = find_msg_converter(ptr, msgId);
> +		if (cv)
> +			ret = cv->deserFunc(data, length);
> +		else
> +			ret = NULL;
> +	} else
> +		ret = NULL;
> +

It should be:

+
+			ret = NULL;
+	} else {
+		ret = NULL;
+	}

The rules on braces are a little bit complicated.  If it's one line
then don't use braces.  If it's two lines and you don't *need* to
use braces then still use braces.

	if (foo) {
		/* some comment */
		frob();
	}

If either side of the if else statement uses braces then use braces
on both.

> +	if (ptr) {
> +		const CsrMsgConvMsgEntry *cv;
> +		u16 msgId = *(u16 *) data;
> +
> +		cv = find_msg_converter(ptr, msgId);
> +	if (cv) {
> +		cv->freeFunc(data);
> +		ret = TRUE;
> +	} else
> +		ret = FALSE;
> +	} else
> +		ret = FALSE;
> +

??

regards,
dan carpenter

