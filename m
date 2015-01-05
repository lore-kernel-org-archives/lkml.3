Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbbAEQO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 11:14:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54257 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbbAEQO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 11:14:26 -0500
Date: Mon, 5 Jan 2015 08:14:07 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] kernfs: Fix kernfs_name_compare
Message-ID: <20150105161407.GA24376@kroah.com>
References: <1417709976-31551-1-git-send-email-linux@rasmusvillemoes.dk>
 <1417819295-18865-1-git-send-email-linux@rasmusvillemoes.dk>
 <20150105141347.GH15833@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150105141347.GH15833@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 09:13:47AM -0500, Tejun Heo wrote:
> On Fri, Dec 05, 2014 at 11:41:33PM +0100, Rasmus Villemoes wrote:
> > Returning a difference from a comparison functions is usually wrong
> > (see acbbe6fbb240 "kcmp: fix standard comparison bug" for the long
> > story). Here there is the additional twist that if the void pointers
> > ns and kn->ns happen to differ by a multiple of 2^32,
> > kernfs_name_compare returns 0, falsely reporting a match to the
> > caller.
> > 
> > Technically 'hash - kn->hash' is ok since the hashes are restricted to
> > 31 bits, but it's better to avoid that subtlety.
> > 
> > Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> And this is a -stable material.  Greg, can you please pick this one
> up?

Will do, thanks.

greg k-h
