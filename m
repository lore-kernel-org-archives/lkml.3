Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab3LPRuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:50:40 -0500
Received: from smtp.citrix.com ([66.165.176.89]:47661 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab3LPRui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:50:38 -0500
X-IronPort-AV: E=Sophos;i="4.95,496,1384300800"; 
   d="scan'208";a="85008425"
Date: Mon, 16 Dec 2013 17:50:36 +0000
From: Wei Liu <wei.liu2@citrix.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: Wei Liu <wei.liu2@citrix.com>, <ian.campbell@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next v2 1/9] xen-netback: Introduce TX grant map
 definitions
Message-ID: <20131216175036.GB25969@zion.uk.xensource.com>
References: <1386892097-15502-1-git-send-email-zoltan.kiss@citrix.com>
 <1386892097-15502-2-git-send-email-zoltan.kiss@citrix.com>
 <20131213153138.GL21900@zion.uk.xensource.com>
 <52AB506E.3040509@citrix.com>
 <20131213191423.GA12582@zion.uk.xensource.com>
 <52AF1A84.3090304@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <52AF1A84.3090304@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 03:21:40PM +0000, Zoltan Kiss wrote:
[...]
> >>>> >
> >>>> >Should this be BUG_ON? AIUI this kthread should be the only one doing
> >>>> >unmap, right?
> >>>The NAPI instance can do it as well if it is a small packet fits
> >>>into PKT_PROT_LEN. But still this scenario shouldn't really happen,
> >>>I was just not sure we have to crash immediately. Maybe handle it as
> >>>a fatal error and destroy the vif?
> >>>
> >It depends. If this is within the trust boundary, i.e. everything at the
> >stage should have been sanitized then we should BUG_ON because there's
> >clearly a bug somewhere in the sanitization process, or in the
> >interaction of various backend routines.
> 
> My understanding is that crashing should be avoided if we can bail
> out somehow. At this point there is clearly a bug in netback
> somewhere, something unmapped that page before it should have
> happened, or at least that array get corrupted somehow. However
> there is a chance that xenvif_fatal_tx_err() can contain the issue,
> and the rest of the system can go unaffected.
> 

That would make debugging much harder if a crash is caused by a previous
corrupted array and we pretend we can carry on serving IMHO. Now netback
is having three routines (NAPI, two kthreads) to serve a single vif, the
interation among them makes bug hard to reproduce.

Wei.
