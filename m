Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbaBUUUB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:20:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985AbaBUUT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:19:59 -0500
Date: Fri, 21 Feb 2014 12:21:27 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>, Jiri Slaby <jslaby@suse.cz>,
        David Herrmann <dh.herrmann@gmail.com>, Werner Fink <werner@suse.de>,
        Hannes Reinecke <hare@suse.de>, Ray Strode <halfline@gmail.com>
Subject: Re: [PATCH 3.13 35/99] tty: Set correct tty name in active sysfs
 attribute
Message-ID: <20140221202127.GA28780@kroah.com>
References: <20140220235118.191692546@linuxfoundation.org>
 <20140220235119.236520201@linuxfoundation.org>
 <CA+5PVA55O2GwUE8oMHShgKgQPA89z5RTbn6yCvOPBMGsf70kBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA55O2GwUE8oMHShgKgQPA89z5RTbn6yCvOPBMGsf70kBw@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 09:48:46AM -0500, Josh Boyer wrote:
> On Thu, Feb 20, 2014 at 6:52 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > 3.13-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Hannes Reinecke <hare@suse.de>
> >
> > commit d8a5dc3033af2fd6d16030d2ee4fbd073460fe54 upstream.
> >
> > The 'active' sysfs attribute should refer to the currently active tty
> > devices the console is running on, not the currently active console.
> >
> > The console structure doesn't refer to any device in sysfs, only the tty
> > the console is running on has.  So we need to print out the tty names in
> > 'active', not the console names.
> >
> > This resolves an issue on s390 platforms in determining the correct
> > console device to use.
> 
> Just to be double sure this is seen, Ray points out that it breaks
> current plymouth because the heuristic changed.  Hold off on this one?

Ray, Josh, can I get some more information about this?  Is this broken
in Linus's tree?  Or did I get the backport wrong here?  What is the
value of the file before and after this patch?

And what is plymouth doing with this file value, it was incorrect
before, what was it using the value for?

thanks,

greg k-h
