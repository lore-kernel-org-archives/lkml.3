Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaKQShR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 13:37:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49971 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaKQShP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 13:37:15 -0500
Date: Mon, 17 Nov 2014 10:37:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Karol Lewandowski <lmctlx@gmail.com>
Cc: pmoore@redhat.com, jkosina@suse.cz, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org, arnd@arndb.de,
        tj@kernel.org, desrt@desrt.ca, simon.mcvittie@collabora.co.uk,
        daniel@zonque.org, dh.herrmann@gmail.com, casey.schaufler@intel.com,
        marcel@holtmann.org, tixxdz@opendz.org,
        javier.martinez@collabora.co.uk, alban.crequy@collabora.co.uk,
        linux-security-module@vger.kernel.org, r.krypa@samsung.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [PATCH 1/5] kdbus: extend structures with security pointer for
 lsm
Message-ID: <20141117183714.GC12343@kroah.com>
References: <54539AF3.6060302@samsung.com>
 <1414773397-26490-1-git-send-email-k.lewandowsk@samsung.com>
 <1414773397-26490-2-git-send-email-k.lewandowsk@samsung.com>
 <20141117014732.GA21745@pix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141117014732.GA21745@pix>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 02:47:32AM +0100, Karol Lewandowski wrote:
> On Fri, Oct 31, 2014 at 05:36:33PM +0100, Karol Lewandowski wrote:
> > Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
> > ---
> >  drivers/misc/kdbus/bus.h        | 2 ++
> >  drivers/misc/kdbus/connection.h | 2 ++
> >  drivers/misc/kdbus/domain.h     | 2 ++
> >  3 files changed, 6 insertions(+)
> > 
> > diff --git a/drivers/misc/kdbus/bus.h b/drivers/misc/kdbus/bus.h
> > index fd9d843..5c403ef 100644
> > --- a/drivers/misc/kdbus/bus.h
> > +++ b/drivers/misc/kdbus/bus.h
> > @@ -49,6 +49,7 @@
> >   * @conn_hash:		Map of connection IDs
> >   * @monitors_list:	Connections that monitor this bus
> >   * @meta:		Meta information about the bus creator
> > + * @security:		LSM security blob
> >   *
> >   * A bus provides a "bus" endpoint / device node.
> >   *
> > @@ -84,6 +85,7 @@ struct kdbus_bus {
> >  	struct list_head monitors_list;
> >  
> >  	struct kdbus_meta *meta;
> > +	void *security;
> 
> One minor note - with possibility of LSM modules trying to access
> these structures it would be worth to have kdbus headers in, say
> include/linux/kdbus or similar globally accessible location.

Yes, that is a good idea.
