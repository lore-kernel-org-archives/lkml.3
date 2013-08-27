Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab3H0IgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:36:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57472 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab3H0IgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:36:18 -0400
Date: Tue, 27 Aug 2013 10:36:09 +0200 (CEST)
From: Jiri Kosina <jiri.kosina@suse.com>
X-X-Sender: jkosina@pobox.suse.cz
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
        Greg KH <gregkh@linuxfoundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 03/18] asymmetric keys: separate the length checking of
 octet string from RSA_I2OSP
In-Reply-To: <20130826112737.GA18300@amd.pavel.ucw.cz>
Message-ID: <alpine.LNX.2.00.1308271012180.2077@pobox.suse.cz>
References: <1377169317-5959-1-git-send-email-jlee@suse.com> <1377169317-5959-4-git-send-email-jlee@suse.com> <20130825160147.GB5171@amd.pavel.ucw.cz> <1377512731.27967.34.camel@linux-s257.site> <20130826112737.GA18300@amd.pavel.ucw.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Aug 2013, Pavel Machek wrote:

> > > > Due to RSA_I2OSP is not only used by signature verification path but also used
> > > > in signature generation path. So, separate the length checking of octet string
> > > > because it's not for generate 0x00 0x01 leading string when used in signature
> > > > generation.
> > > > 
> > > > Reviewed-by: Jiri Kosina <jkosina@suse.cz>
> > > > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> > > 
> > > > +static int RSA_I2OSP(MPI x, size_t xLen, u8 **_X)
> > > > +{
> > > > +	unsigned x_size;
> > > > +	unsigned X_size;
> > > > +	u8 *X = NULL;
> > > 
> > > Is this kernel code or entry into obfuscated C code contest? This is not funny.
> > > 
> > The small "x" is the input integer that will transfer to big "X" that is
> > a octet sting. 
> > 
> > Sorry for I direct give variable name to match with spec, maybe I need
> > use big_X or....
> 
> Having variables that differ only in case is confusing. Actually
> RSA_I2OSP is not a good name for function, either.
> 
> If it converts x into X, perhaps you can name one input and second output?

The variable naming is according to spec, and I believe it makes sense to 
keep it so, no matter how stupid the naming in the spec might be.

Otherwise you have to do mental remapping when looking at the code and the 
spec at the same time, which is very inconvenient.

Would a comment next to the variable declaration, that would point this 
fact out, be satisfactory for you?

-- 
Jiri Kosina
SUSE Labs
