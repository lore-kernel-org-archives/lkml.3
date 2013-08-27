Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab3H0L3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 07:29:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51795 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab3H0L3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 07:29:45 -0400
Date: Tue, 27 Aug 2013 13:29:43 +0200
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
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 11/18] Hibernate: introduced RSA key-pair to verify
 signature of snapshot
Message-ID: <20130827112943.GA20527@amd.pavel.ucw.cz>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <1377169317-5959-12-git-send-email-jlee@suse.com>
 <20130825162554.GH5171@amd.pavel.ucw.cz>
 <1377594283.20140.3.camel@linux-s257.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377594283.20140.3.camel@linux-s257.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > @@ -1205,6 +1290,10 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
> > >  
> > >  	setup_efi_pci(boot_params);
> > >  
> > > +#ifdef CONFIG_SNAPSHOT_VERIFICATION
> > > +	setup_s4_keys(boot_params);
> > > +#endif
> > > +
> > 
> > Move ifdef inside the function?
> 
> OK, I will define a dummy function for non-verification situation.

IIRC you can just put the #ifdef inside the function body. 
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
