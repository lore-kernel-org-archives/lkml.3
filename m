Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab3AZUr3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 15:47:29 -0500
Received: from mail-ia0-f173.google.com ([209.85.210.173]:62687 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab3AZUr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 15:47:27 -0500
Date: Sat, 26 Jan 2013 15:41:18 -0500
From: jake.champlin.27@gmail.com
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: csr: csr_msgconv: Fixed Multiple Coding Style
 Issues
Message-ID: <20130126204117.GC1215@gmail.com>
References: <20130126201431.GA18436@gmail.com>
 <20130126203512.GD4584@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130126203512.GD4584@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan, 
        Ok, thank you. 

        Will fix errors and resubmit. 


-- 
Jake Champlin
jake.champlin.27@gmail.com
<MuttClient>
On Sat, Jan 26, 2013 at 11:35:12PM +0300, Dan Carpenter wrote:
> On Sat, Jan 26, 2013 at 03:14:35PM -0500, Jake Champlin wrote:
> > Resolved 150 Style Errors and 202 Coding Style Warnings.
> > 
> 
> Normally we would prefer that these are broken up into a several
> different patches that each fix one type of style issue.
> 
> [patch 1/x] csr: csr_msgconv: use tab indents
> [patch 2/x] csr: csr_msgconv: put curly braces on the right line
> etc...
> 
> > +	CsrMsgConvPrimEntry *ptr = NULL;
> > +
> > +	if (converter) {
> > +		ptr = converter->profile_converters;
> > +	while (ptr) {
> > +		if (ptr->primType == primType)
> > +			break;
> > +		else
> > +			ptr = ptr->next;
> > +	}
> > +	}
> 
> The while loop should be indented one more time.
> 
> > +	if (ptr) {
> > +		const CsrMsgConvMsgEntry *cv;
> > +		u16 msgId = 0;
> > +		size_t offset = 0;
> > +		CsrUint16Des(&msgId, data, &offset);
> > +
> > +		cv = find_msg_converter(ptr, msgId);
> > +		if (cv)
> > +			ret = cv->deserFunc(data, length);
> > +		else
> > +			ret = NULL;
> > +	} else
> > +		ret = NULL;
> > +
> 
> It should be:
> 
> +
> +			ret = NULL;
> +	} else {
> +		ret = NULL;
> +	}
> 
> The rules on braces are a little bit complicated.  If it's one line
> then don't use braces.  If it's two lines and you don't *need* to
> use braces then still use braces.
> 
> 	if (foo) {
> 		/* some comment */
> 		frob();
> 	}
> 
> If either side of the if else statement uses braces then use braces
> on both.
> 
> > +	if (ptr) {
> > +		const CsrMsgConvMsgEntry *cv;
> > +		u16 msgId = *(u16 *) data;
> > +
> > +		cv = find_msg_converter(ptr, msgId);
> > +	if (cv) {
> > +		cv->freeFunc(data);
> > +		ret = TRUE;
> > +	} else
> > +		ret = FALSE;
> > +	} else
> > +		ret = FALSE;
> > +
> 
> ??
> 
> regards,
> dan carpenter
> 
