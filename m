Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935019Ab3DIOkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:40:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761262Ab3DIOkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:40:32 -0400
Date: Tue, 9 Apr 2013 10:38:52 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] initramfs with digital signature protection
Message-ID: <20130409143852.GH6320@redhat.com>
References: <cover.1360067333.git.dmitry.kasatkin@intel.com>
 <cc87f1242960fad1a9fb44bcec331915e14c832b.1360067333.git.dmitry.kasatkin@intel.com>
 <20130205181926.GA13942@srcf.ucam.org>
 <20130205183436.GC12853@redhat.com>
 <CALLzPKavbsZgHoJrk5iQ0F1fO21SaeEHmCVCh1G1UKCKB3WZZQ@mail.gmail.com>
 <20130405135000.GB6299@redhat.com>
 <1365450229.3847.56.camel@falcor1.watson.ibm.com>
 <20130408200904.GI28292@redhat.com>
 <CA+5PVA43U_kDSV7p0zhQwmK9pwbVb8qAUePU8svQvoPbDA9iCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA43U_kDSV7p0zhQwmK9pwbVb8qAUePU8svQvoPbDA9iCQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 04:17:56PM -0400, Josh Boyer wrote:

[..]
> >> > I was thinking about this point that keys can be loaded from signed
> >> > initramfs. But how is it better than embedding the keys in kernel the
> >> > way we do for module signing and lock down ima keyring before control
> >> > is passed to initramfs.
> >> >
> >> > Reason being, that anyway a user can not put its own keys in signed
> >> > initramfs. Signed initramfs will be shipped by distribution. So then
> >> > it does not matter whether distribution's keys are embedded in the
> >> > kernel or are loaded from signed initramfs.
> >>
> >> Although both the early initramfs and the kernel are signed, building
> >> the keys into the kernel implies a static set of predefined public keys,
> >> while the initramfs could load, in addition to the distro keys, keys
> >> from the UEFI databases.
> >
> > Kernel already loads all the keys from UEFI database and MOK into module
> > keyring.
> 
> Small point of order: there are patches to allow the kernel to do this.
> None of those patches are upstream.

Ok, thanks Josh. We had been talking about copying all the UEFI keys
(including dbx) and MOK keys, so I assumed that patches already went in.

So assuming all that will go in kernel (as it is required for module
signature too), does not look like we will benefit from signed initramfs.

Thanks
Vivek
