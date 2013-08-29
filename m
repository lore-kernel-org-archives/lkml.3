Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab3H2Vcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 17:32:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55912 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3H2Vcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 17:32:48 -0400
Date: Thu, 29 Aug 2013 23:32:50 +0200
From: Pavel Machek <pavel@denx.de>
To: joeyli <jlee@suse.com>
Cc: Florian Weimer <fw@deneb.enyo.de>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        opensuse-kernel@opensuse.org, David Howells <dhowells@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
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
Subject: Re: [RFC PATCH 00/18 v3] Signature verification of hibernate
 snapshot
Message-ID: <20130829213249.GA25940@amd.pavel.ucw.cz>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <87eh9dzg00.fsf@mid.deneb.enyo.de>
 <1377734505.19568.39.camel@linux-s257.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377734505.19568.39.camel@linux-s257.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > >    - Bootloader store the public key to EFI boottime variable by itself
> > >    - Bootloader put The private key to S4SignKey EFI variable for forward to
> > >      kernel.
> > 
> > Is the UEFI NVRAM really suited for such regular updates?
> > 
> 
> Yes, Matthew raised this concern at before. I modified patch to load
> private key in efi stub kernel, before ExitBootServices(), that means we
> don't need generate key-pair at every system boot. So, the above
> procedure of efi bootloader will only run one time. 
> 
> User can enable SNAPSHOT_REGEN_KEYS kernel config to notify efi
> booloader regenerate key-pair for every S4 to improve security if he
> want. So, the key-pair re-generate procedure will only launched when S4
> resume, not every system boot.

How many writes can UEFI NVRAM survive? (Is it NOR?)

"every S4 resume" may be approximately "every boot" for some users...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
