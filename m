Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbaDNOFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:05:01 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42991 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbaDNOFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:05:00 -0400
Date: Mon, 14 Apr 2014 15:04:38 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Oliver Neukum <oneukum@suse.de>
Cc: Johan Hovold <jhovold@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>, Xiao Jin <jin.xiao@intel.com>,
        david.a.cohen@linux.intel.com, yanmin.zhang@intel.com
Subject: Re: [RFC 1/2] n_tty: fix dropped output characters
Message-ID: <20140414150438.2737893d@alan.etchedpixels.co.uk>
In-Reply-To: <1397480749.16591.24.camel@linux-fkkt.site>
References: <20140411093715.GA17522@localhost>
	<1397209285-15471-1-git-send-email-jhovold@gmail.com>
	<20140414135333.1057aac8@alan.etchedpixels.co.uk>
	<1397480749.16591.24.camel@linux-fkkt.site>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2014 15:05:49 +0200
Oliver Neukum <oneukum@suse.de> wrote:

> On Mon, 2014-04-14 at 13:53 +0100, One Thousand Gnomes wrote:
> > On Fri, 11 Apr 2014 11:41:24 +0200
> > Johan Hovold <jhovold@gmail.com> wrote:
> > 
> > > Fix characters being dropped by n_tty_write() due to a failure to
> > > check the return value of tty_put_char() in do_output_char().
> > > 
> > > Characters are currently being dropped by write if a tty driver claims
> > > to have write room available, but still fails to buffer any data
> > 
> > Your driver is buggy. If you advertise a buffer you must honour it and
> > neither shrink nor revoke it.
> 
> Is that a general rule or does it apply only till the next write?

Its a general rule. If you've advertised 5 bytes then you can only
advertise 0 after 5 bytes have been sent your way (or a hangup etc
occurred).

Alan
