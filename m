Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab3IZMWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:22:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47334 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756570Ab3IZMWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:22:12 -0400
Date: Thu, 26 Sep 2013 14:22:10 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: joeyli <jlee@suse.com>, Alan Stern <stern@rowland.harvard.edu>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        opensuse-kernel@opensuse.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Josh Boyer <jwboyer@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate snapshot
Message-ID: <20130926122210.GA30225@suse.cz>
References: <Pine.LNX.4.44L0.1309251723001.26508-100000@netrider.rowland.org>
 <1380161957.32302.42.camel@linux-s257.site>
 <1380192218.32302.69.camel@linux-s257.site>
 <20130926120621.GA7537@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130926120621.GA7537@amd.pavel.ucw.cz>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 02:06:21PM +0200, Pavel Machek wrote:

> > For the symmetric key solution, I will try HMAC (Hash Message
> > Authentication Code). It's already used in networking, hope the
> > performance is not too bad to a big image.
> 
> Kernel already supports crc32 of the hibernation image, you may want
> to take a look how that is done.
> 
> Maybe you want to replace crc32 with cryptographics hash (sha1?) and
> then use only hash for more crypto? That way speed of whatever crypto
> you do should not be an issue.

Well, yes, one could skip the CRC when the signing is enabled to gain a
little speedup.

> Actually...
> 
> Is not it as simple as storing hash of hibernation image into NVRAM
> and then verifying the hash matches the value in NVRAM on next
> startup? No encryption needed. 

First, there is no encryption going on. Only doing a HMAC (digest (hash)
using a key) of the image.

Second, since NVRAM is accessible through efivarsfs, storing the hash in
NVRAM wouldn't prevent an attacker from modifying the hash to match a
modified image.

There is a reason why the key for the HMAC is stored in the NVRAM in a
BootServices variable that isn't accessible from the OS and is
write-protected on hardware level from the OS.

> And that may even be useful for non-secure-boot people, as it ensures
> you boot right image after resume, boot it just once, etc...

The HMAC approach isn't much more complicated, and it gives you all
these benefits even with secure boot disabled.

-- 
Vojtech Pavlik
Director SUSE Labs
