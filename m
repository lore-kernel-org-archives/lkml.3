Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab3H0Mje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 08:39:34 -0400
Received: from mailout01.t-online.de ([194.25.134.80]:59394 "EHLO
	mailout01.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab3H0Mj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 08:39:29 -0400
X-Greylist: delayed 2246 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Aug 2013 08:39:29 EDT
Date: Tue, 27 Aug 2013 14:01:42 +0200
From: Manfred Hollstein <mhollstein@t-online.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: joeyli <jlee@suse.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        opensuse-kernel@opensuse.org, David Howells <dhowells@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
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
Message-ID: <20130827120142.GA4314@saturn.hollstein.homelinux.org>
Mail-Followup-To: Manfred Hollstein <mhollstein@t-online.de>,
	Pavel Machek <pavel@ucw.cz>, joeyli <jlee@suse.com>,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-efi@vger.kernel.org, linux-pm@vger.kernel.org,
	linux-crypto@vger.kernel.org, opensuse-kernel@opensuse.org,
	David Howells <dhowells@redhat.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Len Brown <len.brown@intel.com>, Josh Boyer <jwboyer@redhat.com>,
	Vojtech Pavlik <vojtech@suse.cz>,
	Matt Fleming <matt.fleming@intel.com>,
	James Bottomley <james.bottomley@hansenpartnership.com>,
	Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
	Rusty Russell <rusty@rustcorp.com.au>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
	Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
	Takashi Iwai <tiwai@suse.de>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <1377169317-5959-12-git-send-email-jlee@suse.com>
 <20130825162554.GH5171@amd.pavel.ucw.cz>
 <1377594283.20140.3.camel@linux-s257.site>
 <20130827112943.GA20527@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130827112943.GA20527@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ID: Z1ShPTZfQhnLJfWiwjUC19izcQenFE9Qvacqf+eMNh5AMTDkxciEUnZ7FBBzHU7Q1y
X-TOI-MSGID: 0bbe169a-84aa-4c5c-99bc-892de1e07059
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Aug 2013, 13:29:43 +0200, Pavel Machek wrote:
> > > > @@ -1205,6 +1290,10 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
> > > >  
> > > >  	setup_efi_pci(boot_params);
> > > >  
> > > > +#ifdef CONFIG_SNAPSHOT_VERIFICATION
> > > > +	setup_s4_keys(boot_params);
> > > > +#endif
> > > > +
> > > 
> > > Move ifdef inside the function?
> > 
> > OK, I will define a dummy function for non-verification situation.
> 
> IIRC you can just put the #ifdef inside the function body. 

This is certainly not to be invoked on a frequent basis (and therefore
not on a hot path), but from a more general angle, wouldn't this leave
a(nother) plain "jsr... rts" sequence without any effect other than
burning a few cycles? If the whole function call can be disabled
(ignored) in a certain configuration, it shouldn't call at all, should
it?

Cheers.

l8er
manfred
