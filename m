Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbbAUGP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:15:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbbAUGPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:15:24 -0500
Date: Wed, 21 Jan 2015 11:44:52 +0530
From: Amit Shah <amit.shah@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>, cornelia.huck@de.ibm.com,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 04/16] virtio/console: verify device has config space
Message-ID: <20150121061452.GV31174@grmbl.mre>
References: <1421256142-11512-1-git-send-email-mst@redhat.com>
 <1421256142-11512-5-git-send-email-mst@redhat.com>
 <20150120104040.GJ31174@grmbl.mre>
 <20150120110955.GF26442@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120110955.GF26442@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) 20 Jan 2015 [13:09:55], Michael S. Tsirkin wrote:
> On Tue, Jan 20, 2015 at 04:10:40PM +0530, Amit Shah wrote:
> > On (Wed) 14 Jan 2015 [19:27:35], Michael S. Tsirkin wrote:
> > > Some devices might not implement config space access
> > > (e.g. remoteproc used not to - before 3.9).
> > > virtio/console needs config space access so make it
> > > fail gracefully if not there.
> > 
> > Do we know any such devices?  Wondering what prompted this patch.  If
> > it's just theoretical, I'd rather let it be like this, and pull this
> > in when there's a device that doesn't have config space.
> 
> Yes, with virtio 1.0 config space can be in a separate BAR now.  If
> that's not enabled by BIOS (e.g. out of space), we won't have config
> space.

I'm still not sure whether we should pull in this patch before
actually seeing a failure.

You do have a dev_err which tells why the probe failed, so it's an
acceptable compromise I suppose.

> > Also, just the console functionality (i.e. F_MULTIPORT is unset) is
> > available w/o config space access.
> 
> Supporting this by gracefully disabling F_MULTIPORT
> would require getting this info from driver before
> features are finalized.
> Alternatively, check F_MULTIPORT and only fail if set?
> Let me know, I'll cook up a patch.

Yes, failing only if F_MULTIPORT is set is a better option (if we have
to fail).

> > In fact, getting this patch in
> > would mean remoteproc wouldn't even run in its pre-config days...
> 
> It seems to have get callback unconditionally now - or did I miss
> something?

What I meant was remoteproc doesn't depend on the config space, only
uses the console functionality.  If remoteproc devices didn't expose a
config space, this patch would cause it to lose its console
functionality for no apparent reason.


		Amit
