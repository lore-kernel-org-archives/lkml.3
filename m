Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbaICR4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 13:56:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbaICR4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 13:56:07 -0400
Date: Wed, 3 Sep 2014 10:56:06 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/26] tty: Convert tty_struct bitfield to bools
Message-ID: <20140903175606.GA9740@kroah.com>
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
 <1409693975-1028-22-git-send-email-peter@hurleysoftware.com>
 <20140903115852.5a720754@alan.etchedpixels.co.uk>
 <54070643.9080903@hurleysoftware.com>
 <20140903131919.0d970b6f@alan.etchedpixels.co.uk>
 <54072F75.70107@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54072F75.70107@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 11:10:45AM -0400, Peter Hurley wrote:
> On 09/03/2014 08:19 AM, One Thousand Gnomes wrote:
> >> Ahh. Thanks for the insight, Alan.
> >>
> >> But set_bit() et. al. will generate an incredible amount of churn;
> >> what if I split the fields up to prevent false-sharing?
> > 
> > Do you feel lucky ;-)
> 
> Hahaha  :)
> 
> > I'd rather set_bit and friends were used. They exist largely for this
> > kind of reason and they also have atomic test/set methods which may in
> > the longer term be very useful.
> > 
> > Yes it is churn can't argue with that.
> 
> Yuck. There should be a better way. IXANY mode is suddenly going to
> have a ton of unnecessary bus locks on x86.

True, but at least it will be correct, which I'm guessing today it isn't
:(

> Note the ctrl_status field is a byte as well, which can't be RMW'ed by
> the bit-locked primitives, and definitely should not be aggregated with
> any adjacent field.

Never trust what an ia64 compiler can, and will, do...

greg k-h
