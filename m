Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab3IZEkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 00:40:10 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:44623 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab3IZEkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 00:40:07 -0400
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate
 snapshot
From: joeyli <jlee@suse.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        opensuse-kernel@opensuse.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>
In-Reply-To: <20130926002730.GA26857@amd.pavel.ucw.cz>
References: <Pine.LNX.4.44L0.1309251723001.26508-100000@netrider.rowland.org>
	 <1380147414.18835.36.camel@dabdike.int.hansenpartnership.com>
	 <20130926002730.GA26857@amd.pavel.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Sep 2013 12:40:03 +0800
Message-ID: <1380170403.32302.52.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2013-09-26 於 02:27 +0200，Pavel Machek 提到：
> On Wed 2013-09-25 15:16:54, James Bottomley wrote:
> > On Wed, 2013-09-25 at 17:25 -0400, Alan Stern wrote:
> > > On Wed, 25 Sep 2013, David Howells wrote:
> > > 
> > > > I have pushed some keyrings patches that will likely affect this to:
> > > > 
> > > > 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-devel
> > > > 
> > > > I intend to ask James to pull these into his next branch.  If he's happy to do
> > > > so, I can look at pulling at least your asymmetric keys patch on top of them.
> > > 
> > > This suggests a point that I raised at the Linux Plumbers conference:
> > > 
> > > Why are asymmetric keys used for verifying the hibernation image?  It
> > > seems that a symmetric key would work just as well.  And it would be a
> > > lot quicker to generate, because it wouldn't need any high-precision
> > > integer computations.
> > 
> > The reason is the desire to validate that the previous kernel created
> > something which it passed on to the current kernel (in this case, the
> > hibernation image) untampered with.  To do that, something must be
> > passed to the prior kernel that can be validated but *not* recreated by
> > the current kernel.
> 
> I don't get this. Why is it important that current kernel can't
> recreate the signature?
> 
> Current kernel is not considered malicious (if it were, you have worse
> problems).
> 

Current boot kernel should not malicious especially when UEFI secure
boot enabled.

> 								Pavel
> 
> PS: And yes, it would be nice to have
> Documentation/power/swsusp-uefi.txt (or something) explaining the
> design.
> 

Thanks for your suggestion, I will write the swsusp-uefi.txt to
explaining the design in next version.


Thanks a lot!
Joey Lee

