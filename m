Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935813Ab3DHTn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 15:43:59 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39131 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763317Ab3DHTn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 15:43:57 -0400
Message-ID: <1365450229.3847.56.camel@falcor1.watson.ibm.com>
Subject: Re: [RFC 2/2] initramfs with digital signature protection
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 08 Apr 2013 15:43:49 -0400
In-Reply-To: <20130405135000.GB6299@redhat.com>
References: <cover.1360067333.git.dmitry.kasatkin@intel.com>
	 <cc87f1242960fad1a9fb44bcec331915e14c832b.1360067333.git.dmitry.kasatkin@intel.com>
	 <20130205181926.GA13942@srcf.ucam.org> <20130205183436.GC12853@redhat.com>
	 <CALLzPKavbsZgHoJrk5iQ0F1fO21SaeEHmCVCh1G1UKCKB3WZZQ@mail.gmail.com>
	 <20130405135000.GB6299@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040819-7182-0000-0000-00000624802B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-05 at 09:50 -0400, Vivek Goyal wrote:
> On Tue, Feb 05, 2013 at 11:55:09PM +0200, Kasatkin, Dmitry wrote:
> 
> [..]
> > > Also I am assuming that from signed initramfs, keys will be loaded in
> > > appropriate keyrings and then keyring will be locked so that any
> > > tools from unsigned initramfs can not load additional keys.
> > >
> > 
> > Exactly like that.
> 
> Dmitry,
> 
> [ Following up on this thread after a very long time ]
> 
> I was thinking about this point that keys can be loaded from signed
> initramfs. But how is it better than embedding the keys in kernel the
> way we do for module signing and lock down ima keyring before control
> is passed to initramfs.
> 
> Reason being, that anyway a user can not put its own keys in signed
> initramfs. Signed initramfs will be shipped by distribution. So then
> it does not matter whether distribution's keys are embedded in the
> kernel or are loaded from signed initramfs.

Although both the early initramfs and the kernel are signed, building
the keys into the kernel implies a static set of predefined public keys,
while the initramfs could load, in addition to the distro keys, keys
from the UEFI databases.  (Refer to James Bottomley's post on efivarfs.)
If distro's would sign such an early initramfs, it would allow users to
add their own keys in a safe and secure manner, without requiring them
to rebuild the kernel.

Mimi

