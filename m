Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab3AKPhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 10:37:23 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42027 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752022Ab3AKPhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 10:37:21 -0500
Message-ID: <1357918637.3065.22.camel@dabdike.int.hansenpartnership.com>
Subject: Re: linux-next: build failure after merge of the scsi tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wen Xiong <wenxiong@linux.vnet.ibm.com>,
        Greg KH <greg@kroah.com>, linux-scsi <linux-scsi@vger.kernel.org>
Date: Fri, 11 Jan 2013 15:37:17 +0000
In-Reply-To: <50F02F4E.4070804@linux.vnet.ibm.com>
References: <20130111120323.cdc06081d0fb1c498c9f1779@canb.auug.org.au>
	 <1357889656.3065.2.camel@dabdike.int.hansenpartnership.com>
	 <50F02F4E.4070804@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-11 at 09:27 -0600, Brian King wrote:
> It looks like this was a due to the fact that the new patches
> added __devinit tags in the same merge window the __devinit tag
> itself was getting removed.

Not exactly.  The patch which makes them nops went into 3.8.  Now
there's a patch queued in, Gregs tree I presume, to remove them all and
the #defines which causes the compile failure.

> As to the sparse warnings, this patch fixed the ones that
> were actual bugs in the new code, although we could have
> made that more clear in the patch description.
> 
> http://marc.info/?l=linux-scsi&m=135716576204083&w=2

Ah, thanks ... I've been on holiday for a while, so I did miss that.

> There is one outstanding issue I am aware of which was an
> array bounds compiler warning which looks to be a misdetection
> by the compiler. Wendy and I discussed adding a BUG_ON
> to stop the compiler from complaining.
> 
> Wendy - lets queue these two changes up ASAP. They should both
> be very simple changes.

If it's a simple gcc bug, just ignore it.

I do need you to redo the patches to remove the __dev annotations,
though.  We can't risk introducing a bisect killing compile breakage if
Greg's tree merges before mine in the next merge window.

James


