Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbaDNNFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 09:05:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60919 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbaDNNFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 09:05:52 -0400
Message-ID: <1397480749.16591.24.camel@linux-fkkt.site>
Subject: Re: [RFC 1/2] n_tty: fix dropped output characters
From: Oliver Neukum <oneukum@suse.de>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Johan Hovold <jhovold@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>, Xiao Jin <jin.xiao@intel.com>,
        david.a.cohen@linux.intel.com, yanmin.zhang@intel.com
Date: Mon, 14 Apr 2014 15:05:49 +0200
In-Reply-To: <20140414135333.1057aac8@alan.etchedpixels.co.uk>
References: <20140411093715.GA17522@localhost>
	 <1397209285-15471-1-git-send-email-jhovold@gmail.com>
	 <20140414135333.1057aac8@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-14 at 13:53 +0100, One Thousand Gnomes wrote:
> On Fri, 11 Apr 2014 11:41:24 +0200
> Johan Hovold <jhovold@gmail.com> wrote:
> 
> > Fix characters being dropped by n_tty_write() due to a failure to
> > check the return value of tty_put_char() in do_output_char().
> > 
> > Characters are currently being dropped by write if a tty driver claims
> > to have write room available, but still fails to buffer any data
> 
> Your driver is buggy. If you advertise a buffer you must honour it and
> neither shrink nor revoke it.

Is that a general rule or does it apply only till the next write?

	Regards
		Oliver


