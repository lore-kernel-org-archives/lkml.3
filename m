Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab3KZDPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 22:15:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab3KZDPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 22:15:44 -0500
Date: Mon, 25 Nov 2013 19:16:29 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: channing <chao.bi@intel.com>
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: [PATCH V2] n_gsm: race between ld close and gsmtty open
Message-ID: <20131126031629.GA16763@kroah.com>
References: <1385435645.7741.28.camel@bichao>
 <20131126025432.GA3379@kroah.com>
 <1385436914.7741.40.camel@bichao>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385436914.7741.40.camel@bichao>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 11:35:14AM +0800, channing wrote:
> On Mon, 2013-11-25 at 18:54 -0800, Greg KH wrote:
> > On Tue, Nov 26, 2013 at 11:14:05AM +0800, channing wrote:
> 
> > > This patch is try to avoid it by:
> > > 
> > > 1) in n_gsm driver, use a global gsm mutex lock to avoid gsm_dlci_release() run in
> > > parallel with gsmtty_install();
> The commit is updated here than formal patch set: we use mutex lock in
> patch V2, while use spin lock in patch V1.
> 
> > > 
> > > 2) Increase dlci's ref count in gsmtty_install() instead of in gsmtty_open(), the
> > > purpose is to prevent gsm_dlci_release() releasing dlci after gsmtty_install()
> > > allocats dlci but before gsmtty_open increases dlci's ref count;
> > > 
> > > 3) Decrease dlci's ref count in gsmtty_remove(), a tty framework API, this is the
> > > opposite process of step 2).
> > > 
> > > Signed-off-by: Chao Bi <chao.bi@intel.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > I have not signed off on this additional patch.
> > 
> > What is different from the previous version?  That information needs to
> > be somewhere, otherwise I'm just going to guess and say this is the same
> > as your last one, which was incorrect.
> The difference with previous one is to use a mutex instead of spin lock
> to avoid race, purpose is to avoid sleep in atomic context. I've also
> updated commit a little as above.

Then be explicit as to what has changed somewhere.  We deal with
thousands of patches a week, we can not know that you changed one
sentance in a patch description of a few hundred lines long to know you
made a change to the patch itself as well...

thanks,

greg k-h
