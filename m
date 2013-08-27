Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab3H0NOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 09:14:18 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:45932 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab3H0NOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 09:14:16 -0400
Subject: Re: [PATCH 11/18] Hibernate: introduced RSA key-pair to verify
 signature of snapshot
From: joeyli <jlee@suse.com>
To: Pavel Machek <pavel@ucw.cz>
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
In-Reply-To: <20130827112943.GA20527@amd.pavel.ucw.cz>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
	 <1377169317-5959-12-git-send-email-jlee@suse.com>
	 <20130825162554.GH5171@amd.pavel.ucw.cz>
	 <1377594283.20140.3.camel@linux-s257.site>
	 <20130827112943.GA20527@amd.pavel.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Aug 2013 21:12:39 +0800
Message-ID: <1377609159.20140.32.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 二，2013-08-27 於 13:29 +0200，Pavel Machek 提到：
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
> 									Pavel

I want use inline dummy function like saveable_highmem_page() in
snapshot.c, maybe it's	 better then additional function call?


Thanks a lot!
Joey Lee

