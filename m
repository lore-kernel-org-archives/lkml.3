Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab3FGPmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:42:06 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:31384 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab3FGPmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:42:03 -0400
USER-AGENT: Mutt/1.5.21 (2010-09-15)
MIME-Version: 1.0
Message-ID: <20130607154102.GB24882@phenom.dumpdata.com>
Date: Fri, 7 Jun 2013 08:41:02 -0700 (PDT)
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: david.vrabel@citrix.com, roger.pau@citrix.com,
        xen-devel <xen-devel@lists.xen.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] xen/blkback: Check for insane amounts of request on the
 ring.
References: <1370375826-7311-1-git-send-email-konrad.wilk@oracle.com>
 <51AF7A7502000078000DB95C@nat28.tlf.novell.com>
 <20130605173541.GA12812@phenom.dumpdata.com>
 <51B092F702000078000DBDA8@nat28.tlf.novell.com>
In-Reply-To: <51B092F702000078000DBDA8@nat28.tlf.novell.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 12:47:35PM +0100, Jan Beulich wrote:
> >>> On 05.06.13 at 19:35, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > @@ -230,6 +231,7 @@ static int xen_blkif_map(struct xen_blkif *blkif, unsigned long shared_page,
> >  static void xen_blkif_disconnect(struct xen_blkif *blkif)
> >  {
> >  	if (blkif->xenblkd) {
> > +		wake_up(&blkif->shutdown_wq);
> >  		kthread_stop(blkif->xenblkd);
> >  		blkif->xenblkd = NULL;
> >  	}
> 
> Btw., wouldn't the wake_up() better be done after the kthread_stop(),
> so that when the corresponding wait_event_interruptible() checks
> whether to exit the terminating kthread_should_stop() is guaranteed
> to evaluate to true (otherwise I think there's potential for it to never
> exit)?

I think you are right. I did the change and the tests were OK.
> 
> Jan
> 
