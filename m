Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaAYSCW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 13:02:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbaAYSCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 13:02:21 -0500
Date: Sat, 25 Jan 2014 10:03:20 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, Peter Wu <lekensteyn@gmail.com>
Subject: Re: Freeing of dev->p
Message-ID: <20140125180320.GA30684@kroah.com>
References: <20140108164058.059cf461@endymion.delvare>
 <20140108165628.GA15820@kroah.com>
 <20140108213330.2efbc84c@endymion.delvare>
 <20140110041853.GA32018@kroah.com>
 <20140110153907.08297202@endymion.delvare>
 <20140110152402.GC22533@kroah.com>
 <20140122082911.532e3c25@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122082911.532e3c25@endymion.delvare>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 08:29:11AM +0100, Jean Delvare wrote:
> Hi Greg,
> 
> On Fri, 10 Jan 2014 07:24:02 -0800, Greg Kroah-Hartman wrote:
> > On Fri, Jan 10, 2014 at 03:39:07PM +0100, Jean Delvare wrote:
> > > (...)
> > > Then I suppose we could inline both functions
> > > again, for performance. Well, put in short, really revering
> > > b4028437876866aba4747a655ede00f892089e14 would be the way to go IMHO.
> > >
> > > Really, while I understand your envy to protect driver core internals
> > > from unwanted access, the cost here was simply too high IMHO, both in
> > > terms of getting things right and performance. Some drivers are calling
> > > dev_get_drvdata() directly or indirectly repeatedly at run-time. They
> > > had no reason not to as this used to be so fast, and now it is no
> > > longer an inline function, it has conditionals and a double pointer
> > > indirection...
> > > 
> > > Plus, I can't think of anything really bad that could result from
> > > accessing driver_data directly, contrary to the other members of struct
> > > device_private.
> > 
> > (...)
> > 
> > Thanks for the detailed response, I think I'll just revert most of that
> > patch and see if it's still workable.
> 
> Any news on this?

Stuck with dealing with merge-window issues and conferences, don't
worry, this isn't lost, it's still on my todo list...

thanks for your patience,

greg k-h
