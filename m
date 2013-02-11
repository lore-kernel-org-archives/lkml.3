Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab3BKO6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 09:58:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:64266 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006Ab3BKO6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 09:58:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [char-misc-next 07/11] mei: bus: Implement bus driver data setter/getter
Date: Mon, 11 Feb 2013 14:58:37 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: Tomas Winkler <tomas.winkler@intel.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
References: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com> <20130207225809.GG5072@sortiz-mobl> <20130207235724.GA14612@sortiz-mobl>
In-Reply-To: <20130207235724.GA14612@sortiz-mobl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302111458.37452.arnd@arndb.de>
X-Provags-ID: V02:K0:rasNUA5q9tj15j4g+RWSom1KZKokbvGXmM4ynnwsA5N
 w4SrlsR7irYPeRRldBDCnDv/+R9wYgeeGBesmFC//ay+HPisZA
 jMnGYFx1d8slYhMs+qg7rR1DF63NlzdcqtK+VRhiyWjg9etIIM
 e9hhFrt5djjgwwQlakvu/itRwgMUaU/TRl2QKuIuBdyHtjjO61
 XFpRXLgeit6Q3PutQdVUQEz7dbeag2SJ79D9OL5OPbfI0eMGYf
 W2aD9vU5v/CMC0VqBOW4JOExqrN5DebbKgTRr3KrhV3kXJJvZp
 sXJCq1vsC0rqE5/KwkMF9EldbB1IXxIibaNOELybUgYmKZMkD+
 NuVk8/+dqxyFUMpWBbZA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2013, Samuel Ortiz wrote:
> 
> On Thu, Feb 07, 2013 at 11:58:09PM +0100, Samuel Ortiz wrote:
> > On Thu, Feb 07, 2013 at 10:38:44PM +0000, Arnd Bergmann wrote:
> > > On Thursday 07 February 2013, Tomas Winkler wrote:
> > > > 
> > > > +inline void *mei_bus_get_clientdata(const struct mei_bus_client *client)
> > > > +{
> > > > +       return dev_get_drvdata(&client->dev);
> > > > +}
> > > > +EXPORT_SYMBOL(mei_bus_get_clientdata);
> > > > +
> > > 
> > > Did you really mean to export an inline function?
> > > 
> > > Can you make this a static inline function in a header file instead?
> > Sure, will do.
> Actually, I'd like to keep the mei_bus_client structure opaque to the MEI bus
> drivers. So I'll still export those symbols without inlining them.

Ok, makes sense. I assume when you say "bus driver" you mean what other
subsystems call a "device driver".

	Arnd
