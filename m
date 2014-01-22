Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbaAVH33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 02:29:29 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:48973 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaAVH31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 02:29:27 -0500
Date: Wed, 22 Jan 2014 08:29:11 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Wu <lekensteyn@gmail.com>
Subject: Re: Freeing of dev->p
Message-ID: <20140122082911.532e3c25@endymion.delvare>
In-Reply-To: <20140110152402.GC22533@kroah.com>
References: <20140108164058.059cf461@endymion.delvare>
	<20140108165628.GA15820@kroah.com>
	<20140108213330.2efbc84c@endymion.delvare>
	<20140110041853.GA32018@kroah.com>
	<20140110153907.08297202@endymion.delvare>
	<20140110152402.GC22533@kroah.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Fri, 10 Jan 2014 07:24:02 -0800, Greg Kroah-Hartman wrote:
> On Fri, Jan 10, 2014 at 03:39:07PM +0100, Jean Delvare wrote:
> > (...)
> > Then I suppose we could inline both functions
> > again, for performance. Well, put in short, really revering
> > b4028437876866aba4747a655ede00f892089e14 would be the way to go IMHO.
> >
> > Really, while I understand your envy to protect driver core internals
> > from unwanted access, the cost here was simply too high IMHO, both in
> > terms of getting things right and performance. Some drivers are calling
> > dev_get_drvdata() directly or indirectly repeatedly at run-time. They
> > had no reason not to as this used to be so fast, and now it is no
> > longer an inline function, it has conditionals and a double pointer
> > indirection...
> > 
> > Plus, I can't think of anything really bad that could result from
> > accessing driver_data directly, contrary to the other members of struct
> > device_private.
> 
> (...)
> 
> Thanks for the detailed response, I think I'll just revert most of that
> patch and see if it's still workable.

Any news on this?

-- 
Jean Delvare
