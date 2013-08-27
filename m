Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab3H0Lar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 07:30:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51835 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3H0Lap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 07:30:45 -0400
Date: Tue, 27 Aug 2013 13:30:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: joeyli <jlee@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, opensuse-kernel@opensuse.org,
        David Howells <dhowells@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 17/18] Hibernate: introduced SNAPSHOT_SIG_HASH config
 for select hash algorithm
Message-ID: <20130827113044.GB20527@amd.pavel.ucw.cz>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <1377169317-5959-18-git-send-email-jlee@suse.com>
 <20130825164329.GL5171@amd.pavel.ucw.cz>
 <1377598937.20140.12.camel@linux-s257.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1377598937.20140.12.camel@linux-s257.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2013-08-27 18:22:17, joeyli wrote:
> 於 日，2013-08-25 於 18:43 +0200，Pavel Machek 提到：
> > On Thu 2013-08-22 19:01:56, Lee, Chun-Yi wrote:
> > > This patch introduced SNAPSHOT_SIG_HASH config for user to select which
> > > hash algorithm will be used during signature generation of snapshot.
> > > 
> > > v2:
> > > Add define check of oCONFIG_SNAPSHOT_VERIFICATION in snapshot.c before
> > > declare pkey_hash().
> > > 
> > > Reviewed-by: Jiri Kosina <jkosina@suse.cz>
> > > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> > > ---
> > >  kernel/power/Kconfig    |   46 ++++++++++++++++++++++++++++++++++++++++++++++
> > >  kernel/power/snapshot.c |   27 ++++++++++++++++++++++-----
> > >  2 files changed, 68 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
> > > index b592d88..79b34fa 100644
> > > --- a/kernel/power/Kconfig
> > > +++ b/kernel/power/Kconfig
> > > @@ -78,6 +78,52 @@ config SNAPSHOT_VERIFICATION
> > >  	  dependent on UEFI environment. EFI bootloader should generate the
> > >  	  key-pair.
> > >  
> > > +choice
> > > +	prompt "Which hash algorithm should snapshot be signed with?"
> > > +        depends on SNAPSHOT_VERIFICATION
> > > +        help
> > > +          This determines which sort of hashing algorithm will be used during
> > > +          signature generation of snapshot. This algorithm _must_ be built into
> > > +	  the kernel directly so that signature verification can take place.
> > > +	  It is not possible to load a signed snapshot containing the algorithm
> > > +	  to check the signature on that module.
> > 
> > Like if 1000 ifdefs you already added to the code are not enough, you
> > make some new ones?
> > 									Pavel
> > 
> 
> This SNAPSHOT_SIG_HASH kernel config is to select which SHA algorithms
> used for generate digest of snapshot. The configuration will captured by
> a const char* in code:
> 
> +static const char *snapshot_hash = CONFIG_SNAPSHOT_SIG_HASH;
> +
> +static int pkey_hash(void)
> 
> So, there doesn't have any ifdef block derived from this new config.

I'd say select one hash function, and use it. There's no need to make
it configurable.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
