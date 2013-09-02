Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab3IBCPS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 22:15:18 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:54387 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab3IBCPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 22:15:15 -0400
Subject: Re: [RFC PATCH 00/18 v3] Signature verification of hibernate
 snapshot
From: joeyli <jlee@suse.com>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        opensuse-kernel@opensuse.org, David Howells <dhowells@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
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
In-Reply-To: <87vc2ksdfa.fsf@mid.deneb.enyo.de>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
	 <87eh9dzg00.fsf@mid.deneb.enyo.de>
	 <1377734505.19568.39.camel@linux-s257.site>
	 <87r4d8vn71.fsf@mid.deneb.enyo.de> <20130901160429.GA1375@srcf.ucam.org>
	 <87vc2ksdfa.fsf@mid.deneb.enyo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Sep 2013 10:12:22 +0800
Message-ID: <1378087942.7080.75.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 日，2013-09-01 於 18:40 +0200，Florian Weimer 提到：
> * Matthew Garrett:
> 
> > On Sun, Sep 01, 2013 at 12:41:22PM +0200, Florian Weimer wrote:
> >
> >> But if you don't generate fresh keys on every boot, the persistent
> >> keys are mor exposed to other UEFI applications.  Correct me if I'm
> >> wrong, but I don't think UEFI variables are segregated between
> >> different UEFI applications, so if anyone gets a generic UEFI variable
> >> dumper (or setter) signed by the trusted key, this cryptographic
> >> validation of hibernate snapshots is bypassable.
> >
> > If anyone can execute arbitrary code in your UEFI environment then 
> > you've already lost.
> 
> This is not about arbitrary code execution.  The problematic
> applications which conflict with this proposed functionality are not
> necessarily malicious by themselves and even potentially useful.
> 
> For example, if you want to provision a bunch of machines and you have
> to set certain UEFI variables, it might be helpful to do so in an
> unattended fashion, just by booting from a USB stick with a suitable
> UEFI application.  Is this evil?  I don't think so.
> --

Yes, if there have the kind of UEFI tools like you said, and it leak to
attacker, then we lost.

Even we re-generate key-pair for every S4, the tool, if it can set
variable, means it can replace the public key that was stored by efi
bootloader in bootservices variable. Then we still lost.

When the tool can only dump variable but not set, then re-generate
key-pair to every S4 can prevent it. If the tool can also set variable,
then I don't think there have any way to protect key-pair in UEFI
variables.

Using TPM is a way to protect key-pair, but user need key-in password
when generate and use key to sign stuff. It noises to user, but the best
way to keep the password is in brain.


Thanks a lot!
Joey Lee

