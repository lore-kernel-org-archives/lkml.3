Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935947Ab3DHUJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:09:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935850Ab3DHUJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:09:21 -0400
Date: Mon, 8 Apr 2013 16:09:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] initramfs with digital signature protection
Message-ID: <20130408200904.GI28292@redhat.com>
References: <cover.1360067333.git.dmitry.kasatkin@intel.com>
 <cc87f1242960fad1a9fb44bcec331915e14c832b.1360067333.git.dmitry.kasatkin@intel.com>
 <20130205181926.GA13942@srcf.ucam.org>
 <20130205183436.GC12853@redhat.com>
 <CALLzPKavbsZgHoJrk5iQ0F1fO21SaeEHmCVCh1G1UKCKB3WZZQ@mail.gmail.com>
 <20130405135000.GB6299@redhat.com>
 <1365450229.3847.56.camel@falcor1.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365450229.3847.56.camel@falcor1.watson.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 03:43:49PM -0400, Mimi Zohar wrote:
> On Fri, 2013-04-05 at 09:50 -0400, Vivek Goyal wrote:
> > On Tue, Feb 05, 2013 at 11:55:09PM +0200, Kasatkin, Dmitry wrote:
> > 
> > [..]
> > > > Also I am assuming that from signed initramfs, keys will be loaded in
> > > > appropriate keyrings and then keyring will be locked so that any
> > > > tools from unsigned initramfs can not load additional keys.
> > > >
> > > 
> > > Exactly like that.
> > 
> > Dmitry,
> > 
> > [ Following up on this thread after a very long time ]
> > 
> > I was thinking about this point that keys can be loaded from signed
> > initramfs. But how is it better than embedding the keys in kernel the
> > way we do for module signing and lock down ima keyring before control
> > is passed to initramfs.
> > 
> > Reason being, that anyway a user can not put its own keys in signed
> > initramfs. Signed initramfs will be shipped by distribution. So then
> > it does not matter whether distribution's keys are embedded in the
> > kernel or are loaded from signed initramfs.
> 
> Although both the early initramfs and the kernel are signed, building
> the keys into the kernel implies a static set of predefined public keys,
> while the initramfs could load, in addition to the distro keys, keys
> from the UEFI databases.

Kernel already loads all the keys from UEFI database and MOK into module
keyring.

So that can be true for IMA too. A user can add its keys to UEFI database
or MOK and reboot the system and those keys should show up in kernel
keyring.

In addition any keys embedded in kernel at build time will be loaded too.

>  (Refer to James Bottomley's post on efivarfs.)

Are you referring to following link.

http://blog.hansenpartnership.com/efitools-1-4-with-linux-key-manipulation-utilities-released/

This one seems to be talking about tools for adding your own keys to
UEFI database if one has PK and KEK.

> If distro's would sign such an early initramfs, it would allow users to
> add their own keys in a safe and secure manner, without requiring them
> to rebuild the kernel.
> 

Sorry, I did not understand this part. Even if user adds its own keys
in UEFI database (using efivarfs filesystem), it does not require
rebuiling kernel. Over next reboot these keys should show up in kernel
keyring. So does not look like we will gain anything by creating a signed
initramfs.

Thanks
Vivek
