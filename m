Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657AbaDJSWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:22:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47937 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbaDJSV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:21:59 -0400
Date: Thu, 10 Apr 2014 11:24:32 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core: Move driver_data back to struct device
Message-ID: <20140410182432.GA21422@kroah.com>
References: <20140407105322.2eae6b97@endymion.delvare>
 <20140407205815.GA8043@kroah.com>
 <20140410095014.3dc234ea@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410095014.3dc234ea@endymion.delvare>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 09:50:14AM +0200, Jean Delvare wrote:
> Hi Greg,
> 
> On Mon, 7 Apr 2014 13:58:15 -0700, Greg Kroah-Hartman wrote:
> > On Mon, Apr 07, 2014 at 10:53:22AM +0200, Jean Delvare wrote:
> > > Having to allocate memory as part of dev_set_drvdata() is a problem
> > > because that memory may never get freed if the device itself is not
> > > created. So move driver_data back to struct device.
> > > 
> > > This is a partial revert of commit b4028437.
> > > 
> > > Signed-off-by: Jean Delvare <jdelvare@suse.de>
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > > Greg, we discussed that back in January (in a thread named "Freeing of
> > > dev->p") but I did not hear back from you and I can't see this fix in
> > > your driver-core tree.
> > 
> > Thanks for doing this, I'll queue this up after -rc1 is out.  I still
> > have that thread in my TODO list, unfortunatly, higher-priority items
> > keep bumping it down :(
> 
> No problem, I understand.
> 
> Meanwhile I have prepared a patch set with all the cleanups that could
> go in after that one, basically reverting all of commit b4028437 step
> by step. If you want to take a look, it's at:
>   http://jdelvare.nerim.net/devel/linux-3/driver-core/
> 
> FWIW the full patch set shaves about 1.2 MB off an allmodconfig x86_64
> build. And it certainly comes with some performance gains too.
> 
> I can post the whole set now if you want, I just did not want to throw
> too much at you if you are already swamped.

Sure, please send them to me, my "swampedness" isn't an issue for
queueing up patches, it helps, as they will then have to be dealt with
in my queue :)

thanks,

greg k-h
