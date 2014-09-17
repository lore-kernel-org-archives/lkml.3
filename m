Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbaIQKBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 06:01:01 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:60315 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbaIQKA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 06:00:59 -0400
Date: Wed, 17 Sep 2014 12:01:26 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Fabian Frederick <fabf@skynet.be>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        peter@hurleysoftware.com
Subject: Re: [PATCH 0/9 linux-next] drivers/gpu/drm: use container_of where
 possible
Message-ID: <20140917100126.GF31703@phenom.ffwll.local>
Mail-Followup-To: Fabian Frederick <fabf@skynet.be>,
	One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	peter@hurleysoftware.com
References: <1410712823-29137-1-git-send-email-fabf@skynet.be>
 <20140915001356.2e05d782@alan.etchedpixels.co.uk>
 <1669797975.16695.1410804954304.open-xchange@webmail.nmp.skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1669797975.16695.1410804954304.open-xchange@webmail.nmp.skynet.be>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 08:15:54PM +0200, Fabian Frederick wrote:
> 
> 
> > On 15 September 2014 at 01:13 One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
> > wrote:
> >
> >
> > On Sun, 14 Sep 2014 18:40:13 +0200
> > Fabian Frederick <fabf@skynet.be> wrote:
> >
> > > Small patchset using container_of instead of casting on first structure
> > > member address.
> >
> > Why. Container_of is useful for random offsets but its just convoluting
> > and confusing code which is designed with the fields intentionally at the
> > start.
> >
> > Alan
> 
> What if someone doesn't know about that intention one day and inserts
> some field in the structure at the "wrong place" ?
> This would need at least some comment in each declaration
> but once again it's hard to control.One other way is to
> commonly use container_of and get rid of every casting with
> some semantic script.
> 
> Peter has been asking for container_of in the following:
> 
> http://marc.info/?l=linux-arm-kernel&m=140838705729653&w=2
> 
> 
> struct uart_amba_port *uap = (struct uart_amba_port *)port
> 
> (port/uart_port is the first field in uart_amba_port though)

fwiw I like this and I've picked it up into my topic/core-stuff branch. So
if driver writers don't outright nack this it'll all land in Dave's
drm-next (probably still for 3.18).
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
