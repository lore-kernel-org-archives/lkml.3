Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab3IZKoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 06:44:14 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:50727 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414Ab3IZKoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 06:44:10 -0400
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate
 snapshot
From: joeyli <jlee@suse.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        opensuse-kernel@opensuse.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>
In-Reply-To: <1380161957.32302.42.camel@linux-s257.site>
References: <Pine.LNX.4.44L0.1309251723001.26508-100000@netrider.rowland.org>
	 <1380161957.32302.42.camel@linux-s257.site>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Sep 2013 18:43:38 +0800
Message-ID: <1380192218.32302.69.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2013-09-26 於 10:19 +0800，joeyli 提到：
> 於 三，2013-09-25 於 17:25 -0400，Alan Stern 提到：
> > On Wed, 25 Sep 2013, David Howells wrote:
> > 
> > > I have pushed some keyrings patches that will likely affect this to:
> > > 
> > > 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-devel
> > > 
> > > I intend to ask James to pull these into his next branch.  If he's happy to do
> > > so, I can look at pulling at least your asymmetric keys patch on top of them.
> > 
> > This suggests a point that I raised at the Linux Plumbers conference:
> > 
> > Why are asymmetric keys used for verifying the hibernation image?  It
> > seems that a symmetric key would work just as well.  And it would be a
> > lot quicker to generate, because it wouldn't need any high-precision
> > integer computations.
> > 
> > Alan Stern
> > 
> > 
> 
> Per my understood, it's like add salt to snapshot when generate
> signature, then remove the salt when store the snapshot to swap. (or
> pass snapshot to userland).
> 
> Let me explain the symmetric key solution base on my understand:
> 
>  + EFI stub kernel generate a hash value from a random seed, then store
> it to EFi boot varaible. It should protected by UEFI secure boot
> environment.
> 
>  + When hibernate launched:
>     - Kernel create the snapshot image of memory. It's included the
> random hash value(salt) that generated in EFI stub stage.
>     - Then kernel hash the snapshot image, put the hash to snapshot
> header, just like current asymmetric keys solution.
>     - Kernel erase the salt in snapshot image before it go to swap or
> pass to userspace tool.
> 
>  + When hibernate resume:
>     - Kernel or userspace tool load the snapshot(without salt) from swap
> to temporary memory space.
>     - Kernel fill the salt back to snapshot image in memory, hash it.
>     - Kernel compare the hash with the hash that put in snapshot header.
>     - Verification done! The follow-up action as current solution.
> 
> Please current me if I missed anything.
> 
> 
> Thanks a lot!
> Joey Lee
> 

For the symmetric key solution, I will try HMAC (Hash Message
Authentication Code). It's already used in networking, hope the
performance is not too bad to a big image.


Thanks
Joey Lee

