Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab3HZK07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 06:26:59 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:60054 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892Ab3HZK04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 06:26:56 -0400
Subject: Re: [PATCH 03/18] asymmetric keys: separate the length checking of
 octet string from RSA_I2OSP
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
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>
In-Reply-To: <20130825160147.GB5171@amd.pavel.ucw.cz>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
	 <1377169317-5959-4-git-send-email-jlee@suse.com>
	 <20130825160147.GB5171@amd.pavel.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Aug 2013 18:25:31 +0800
Message-ID: <1377512731.27967.34.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 日，2013-08-25 於 18:01 +0200，Pavel Machek 提到：
> On Thu 2013-08-22 19:01:42, Lee, Chun-Yi wrote:
> > Due to RSA_I2OSP is not only used by signature verification path but also used
> > in signature generation path. So, separate the length checking of octet string
> > because it's not for generate 0x00 0x01 leading string when used in signature
> > generation.
> > 
> > Reviewed-by: Jiri Kosina <jkosina@suse.cz>
> > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> 
> > +static int RSA_I2OSP(MPI x, size_t xLen, u8 **_X)
> > +{
> > +	unsigned x_size;
> > +	unsigned X_size;
> > +	u8 *X = NULL;
> 
> Is this kernel code or entry into obfuscated C code contest? This is not funny.
> 
> 									Pavel

The small "x" is the input integer that will transfer to big "X" that is
a octet sting. 

Sorry for I direct give variable name to match with spec, maybe I need
use big_X or....

Do you have good suggest for the naming?


Thanks a lot!
Joey Lee


