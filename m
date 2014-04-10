Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965389AbaDJHuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 03:50:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43064 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933236AbaDJHuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 03:50:16 -0400
Date: Thu, 10 Apr 2014 09:50:14 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core: Move driver_data back to struct device
Message-ID: <20140410095014.3dc234ea@endymion.delvare>
In-Reply-To: <20140407205815.GA8043@kroah.com>
References: <20140407105322.2eae6b97@endymion.delvare>
	<20140407205815.GA8043@kroah.com>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Mon, 7 Apr 2014 13:58:15 -0700, Greg Kroah-Hartman wrote:
> On Mon, Apr 07, 2014 at 10:53:22AM +0200, Jean Delvare wrote:
> > Having to allocate memory as part of dev_set_drvdata() is a problem
> > because that memory may never get freed if the device itself is not
> > created. So move driver_data back to struct device.
> > 
> > This is a partial revert of commit b4028437.
> > 
> > Signed-off-by: Jean Delvare <jdelvare@suse.de>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> > Greg, we discussed that back in January (in a thread named "Freeing of
> > dev->p") but I did not hear back from you and I can't see this fix in
> > your driver-core tree.
> 
> Thanks for doing this, I'll queue this up after -rc1 is out.  I still
> have that thread in my TODO list, unfortunatly, higher-priority items
> keep bumping it down :(

No problem, I understand.

Meanwhile I have prepared a patch set with all the cleanups that could
go in after that one, basically reverting all of commit b4028437 step
by step. If you want to take a look, it's at:
  http://jdelvare.nerim.net/devel/linux-3/driver-core/

FWIW the full patch set shaves about 1.2 MB off an allmodconfig x86_64
build. And it certainly comes with some performance gains too.

I can post the whole set now if you want, I just did not want to throw
too much at you if you are already swamped.

Also, I can merge some of these patches together if you think I went
too fine-grained.

Thanks,
-- 
Jean Delvare
SUSE L3 Support
