Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab3BYQtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 11:49:39 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:25563 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3BYQti convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 11:49:38 -0500
Date: Mon, 25 Feb 2013 11:49:29 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH] xen-blkfront: switch from llist to list
Message-ID: <20130225164929.GB10672@phenom.dumpdata.com>
References: <1360951381-26313-1-git-send-email-roger.pau@citrix.com>
 <20130215185644.GB29539@phenom.dumpdata.com>
 <511E88B4.7060205@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <511E88B4.7060205@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 08:12:52PM +0100, Roger Pau Monné wrote:
> On 15/02/13 19:56, Konrad Rzeszutek Wilk wrote:
> >> Should be backported to 3.8 stable.
> > 
> > Lets do one thing at a time.
> > 
> > The patch I have in the tree (and that I've asked Jens to pull for 3.9 - so
> > he might have already in his tree) is the old hybrid where we still use llist
> > but change the loop from 'for' to 'while'.
> > 
> > This is the stable/for-jens-3.8 tree in git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git 
> > 
> > Could you rebase your patch on top of that tree and just simplify the loop?
> > 
> > Sorry about the mess about this - but I had already pulled the trigger
> > so to say - hoping that Jens would pull the tree and do a git pull to Linus.
> > 
> > And you are absolutly sure that we don't need any extra locking when switching
> > over to list_head? Say if blkif_completion is called while we are
> > processing in blkif_queue_request and doing ?
> 
> Will recheck it, but blkif_completition is called with the io_lock hold,
> as does blkif_queue_request (I've added extra assert_spin_locked before
> every list modification).

Can you rebase this patch on top of 'stable/for-jens-3.9' when you get a chance
please?

Thanks!
