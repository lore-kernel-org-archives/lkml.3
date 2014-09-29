Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbaI2Sze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:55:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40972 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbaI2Szd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:55:33 -0400
Date: Mon, 29 Sep 2014 20:55:27 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, gregkh@linuxfoundation.org,
        dmitry.torokhov@gmail.com, tiwai@suse.de, arjan@linux.intel.com,
        teg@jklm.no, rmilasan@suse.com, werner@suse.com, oleg@redhat.com,
        hare@suse.com, bpoirier@suse.de, santosh@chelsio.com, pmladek@suse.cz,
        dbueso@suse.com, linux-kernel@vger.kernel.org,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-edac@vger.kernel.org
Subject: Re: [PATCH v1 2/5] driver-core: enable drivers to opt-out of async
	probe
Message-ID: <20140929185527.GT17349@wotan.suse.de>
References: <1411768637-6809-1-git-send-email-mcgrof@do-not-panic.com> <1411768637-6809-3-git-send-email-mcgrof@do-not-panic.com> <20140928143324.GA5023@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140928143324.GA5023@mtj.dyndns.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 10:33:24AM -0400, Tejun Heo wrote:
> On Fri, Sep 26, 2014 at 02:57:14PM -0700, Luis R. Rodriguez wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > 
> > We'll soon add generic support for asynchronous probe, before
> > that gets merged lets let drivers annotate if they should never
> > probe asynchronously.
> > 
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Arjan van de Ven <arjan@linux.intel.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Doug Thompson <dougthompson@xmission.com>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > Cc: linux-edac@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> > ---
> >  include/linux/device.h | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/include/linux/device.h b/include/linux/device.h
> > index 43d183a..4de6328 100644
> > --- a/include/linux/device.h
> > +++ b/include/linux/device.h
> > @@ -200,6 +200,10 @@ extern struct klist *bus_get_device_klist(struct bus_type *bus);
> >   * @owner:	The module owner.
> >   * @mod_name:	Used for built-in modules.
> >   * @suppress_bind_attrs: Disables bind/unbind via sysfs.
> > + * @sync_probe: requests probe to be run always be run synchronously even
> 
> "be run" repeated in the sentence.
> 
> > + * 	if userspace asked us to run asynchronously. Some devices drivers
> > + * 	may be known to not work well with async probe, use this to annotate
> > + * 	your driver if you know it needs synchronous probe.
> 
> Maybe something like "Use this to annotate drivers which don't work
> well with async probe." is better?

Sure.

> The formatting seems inconsistent with other comments.

Fixed.

  LUis
