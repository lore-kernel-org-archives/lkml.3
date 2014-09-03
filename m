Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891AbaICOno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 10:43:44 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:55038 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932402AbaICOnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 10:43:42 -0400
Date: Wed, 3 Sep 2014 20:13:25 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, sparmaintainer@unisys.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: unisys: uislib: uisqueue.c: rewrite of
 do_locked_client_insert
Message-ID: <20140903144325.GA15176@sudip-PC>
References: <1409681795-23262-1-git-send-email-sudipm.mukherjee@gmail.com>
 <20140903084038.GE6600@mwanda>
 <20140903085944.GA1184@sudip-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140903085944.GA1184@sudip-PC>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 02:29:44PM +0530, Sudip Mukherjee wrote:
> On Wed, Sep 03, 2014 at 11:40:38AM +0300, Dan Carpenter wrote:
> > On Tue, Sep 02, 2014 at 11:46:35PM +0530, Sudip Mukherjee wrote:
> > > From: Sudip Mukherjee <sudip@vectorindia.org>
> > 
> > I really would prefer if you just figured out your email settings so
> > this isn't needed.  The From: header is mostly used for people
> > forwarding patches from other people.  We have allowed people to use
> > the From header like this if they can't get their corporate email
> > configured properly but I try to discorage it.  If everyone starts using
> > From headers like this then it becomes a pain to deal with.
> > 
> I will configure the corporate mail. I am the server admin , so there should
> not be any problem in settings. :)
> 
v4 of the patch was sent from the corporate mail. The settings were done.
But the problem is coming in a different area. I have given strict DMARC check 
for the corporate mail server. DMARC = domain based message authentication.
So the mail i sent reached all the list subscriber from a different server than 
our designated server , and as a result it has been marked as spam in many places.
I have already received a few complaints regarding that.
Is there any other way that i send the patch from my personal account , 
and use my corporate mail in Signed-off-by ... 

thanks
sudip

> > > 
> > > removed unused variables
> > > fixed sparse warning of context imbalance in 'do_locked_client_insert'
> > >                          different lock contexts for basic block
> > > 
> > > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > > ---
> > > 
> > 
> > This patch is much better and more interesting, but I still want some
> > more changes.
> > 
> I have already sent v3 of the patch just before your mail , based on 
> what greg k-h has suggested about the commnent. Please discard that.
> 
> > > v1 of the patch of the patch just fixed the sparse warning.
> > > On suggestion of Dan Carpenter v2 is the total rewrite of the function.
> > > Two of the function arguments (interruptHandle,channelId) are also not used. Wanted to remove them as well , 
> > > but then thought maybe the original author have planned for some use of those variables.
> > 
> > In the kernel we don't put code in until we are ready to use it.  Don't
> > worry about future changes.  But on the other hand, don't remove the
> > parameters in this patch because that is doing too many changes in one
> > patch.  It would have to be done in a follow on patch if you decide to
> > do it.
> > 
> > > -	if (locked) {
> > > -		spin_unlock_irqrestore((spinlock_t *) lock, flags);
> > > -		locked = 0;
> > > +		goto unlock;
> > > +	visor_signalqueue_empty(queueinfo->chan, whichqueue);
> > 
> > Just remove this function.  But mention it in the changelog in case
> > there are side effects.
> > 
> > > +	/*visor_signal_insert() only return 0 or 1 */
> > 
> > Don't put obvious comments like this.  A normal reader will assume that
> > this function is boolean based on how it is used.
> > 
> > > +	if (visor_signal_insert(queueinfo->chan, whichqueue, pSignal) == 1) {
> > 
> > Don't put the == 1.  In terms of English, 1 really is intended as
> > "success" and not the number one.  Also don't test for == true or
> > == false.
> > 
> > 	if (foo) {
> > 	if (foo == true) {
> > 
> > These two statement *mean* the same thing in terms of English, but the
> > first one is simpler and less wordy.
> > 
> > regards,
> > dan carpenter
> 
> thanks
> sudip
