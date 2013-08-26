Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab3HZL1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:27:41 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38753 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856Ab3HZL1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:27:39 -0400
Date: Mon, 26 Aug 2013 13:27:37 +0200
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
Subject: Re: [PATCH 03/18] asymmetric keys: separate the length checking of
 octet string from RSA_I2OSP
Message-ID: <20130826112737.GA18300@amd.pavel.ucw.cz>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <1377169317-5959-4-git-send-email-jlee@suse.com>
 <20130825160147.GB5171@amd.pavel.ucw.cz>
 <1377512731.27967.34.camel@linux-s257.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377512731.27967.34.camel@linux-s257.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Due to RSA_I2OSP is not only used by signature verification path but also used
> > > in signature generation path. So, separate the length checking of octet string
> > > because it's not for generate 0x00 0x01 leading string when used in signature
> > > generation.
> > > 
> > > Reviewed-by: Jiri Kosina <jkosina@suse.cz>
> > > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> > 
> > > +static int RSA_I2OSP(MPI x, size_t xLen, u8 **_X)
> > > +{
> > > +	unsigned x_size;
> > > +	unsigned X_size;
> > > +	u8 *X = NULL;
> > 
> > Is this kernel code or entry into obfuscated C code contest? This is not funny.
> > 
> The small "x" is the input integer that will transfer to big "X" that is
> a octet sting. 
> 
> Sorry for I direct give variable name to match with spec, maybe I need
> use big_X or....

Having variables that differ only in case is confusing. Actually
RSA_I2OSP is not a good name for function, either.

If it converts x into X, perhaps you can name one input and second output?

> Do you have good suggest for the naming?

Not really, sorry.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
