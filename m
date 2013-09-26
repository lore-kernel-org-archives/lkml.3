Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab3IZM4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:56:25 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:41240 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554Ab3IZM4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:56:22 -0400
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate
 snapshot
From: joeyli <jlee@suse.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        opensuse-kernel@opensuse.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
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
In-Reply-To: <20130926120621.GA7537@amd.pavel.ucw.cz>
References: <Pine.LNX.4.44L0.1309251723001.26508-100000@netrider.rowland.org>
	 <1380161957.32302.42.camel@linux-s257.site>
	 <1380192218.32302.69.camel@linux-s257.site>
	 <20130926120621.GA7537@amd.pavel.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Sep 2013 20:56:10 +0800
Message-ID: <1380200170.32302.85.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2013-09-26 於 14:06 +0200，Pavel Machek 提到：
> Hi!
> 
> > For the symmetric key solution, I will try HMAC (Hash Message
> > Authentication Code). It's already used in networking, hope the
> > performance is not too bad to a big image.
> 
> Kernel already supports crc32 of the hibernation image, you may want
> to take a look how that is done.

In current kernel design, The crc32 is only for the LZO in-kernel
hibernate, doesn't apply to non-compress hibernate and userspace
hibernate.

Put signature to snapshot header can support any kind of caller that's
trigger hibernate. Any userspace hibernate tool will take the snapshot
image from kernel, so, we need put the signature(or hash result) to
snapshot header before userspace write it to anywhere. 

> 
> Maybe you want to replace crc32 with cryptographics hash (sha1?) and
> then use only hash for more crypto? That way speed of whatever crypto
> you do should not be an issue.

That speed of hash is calculated from non-compress snapshot image, does
not overlap with crc32.

> 
> Actually...
> 
> Is not it as simple as storing hash of hibernation image into NVRAM
> and then verifying the hash matches the value in NVRAM on next
> startup? No encryption needed. 
> 
> And that may even be useful for non-secure-boot people, as it ensures
> you boot right image after resume, boot it just once, etc...
> 
> 									Pavel

The HMAC approach will not encrypt, just put the key of HMAC to boottime
variable. 

If user doesn't enable UEFI secure boot, that's fine, the key of HMAC
still cannot access in OS runtime. 
If user enable UEFI secure boot, then that's better! Because all EFI
file will signed by the manufacturers or OSVs to make sure the code is
secure, will not pass the key to runtime.


Thanks a lot!
Joey Lee


