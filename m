Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808Ab3BKQDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 11:03:40 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60099 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614Ab3BKQDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 11:03:38 -0500
Date: Mon, 11 Feb 2013 08:03:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Tomas Winkler <tomas.winkler@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 07/11] mei: bus: Implement bus driver data
 setter/getter
Message-ID: <20130211160346.GA1534@kroah.com>
References: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com>
 <20130207225809.GG5072@sortiz-mobl>
 <20130207235724.GA14612@sortiz-mobl>
 <201302111458.37452.arnd@arndb.de>
 <20130211152929.GS20996@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130211152929.GS20996@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 04:29:29PM +0100, Samuel Ortiz wrote:
> Hi Arnd,
> 
> On Mon, Feb 11, 2013 at 02:58:37PM +0000, Arnd Bergmann wrote:
> > On Thursday 07 February 2013, Samuel Ortiz wrote:
> > > 
> > > On Thu, Feb 07, 2013 at 11:58:09PM +0100, Samuel Ortiz wrote:
> > > > On Thu, Feb 07, 2013 at 10:38:44PM +0000, Arnd Bergmann wrote:
> > > > > On Thursday 07 February 2013, Tomas Winkler wrote:
> > > > > > 
> > > > > > +inline void *mei_bus_get_clientdata(const struct mei_bus_client *client)
> > > > > > +{
> > > > > > +       return dev_get_drvdata(&client->dev);
> > > > > > +}
> > > > > > +EXPORT_SYMBOL(mei_bus_get_clientdata);
> > > > > > +
> > > > > 
> > > > > Did you really mean to export an inline function?
> > > > > 
> > > > > Can you make this a static inline function in a header file instead?
> > > > Sure, will do.
> > > Actually, I'd like to keep the mei_bus_client structure opaque to the MEI bus
> > > drivers. So I'll still export those symbols without inlining them.
> > 
> > Ok, makes sense. I assume when you say "bus driver" you mean what other
> > subsystems call a "device driver".
> That's correct, yes.

Thanks for clearing that up.  So, in your next revision, can you use the
"proper" names for everything so that we all can understand the code
easier as it will follow the normal standards for kernel driver model
interaction?

thanks,

greg k-h
