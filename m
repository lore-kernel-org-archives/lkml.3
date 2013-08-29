Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab3H2WdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 18:33:13 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:46743 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab3H2WdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 18:33:11 -0400
Subject: Re: [RFC PATCH 00/18 v3] Signature verification of hibernate
 snapshot
From: joeyli <jlee@suse.com>
To: Pavel Machek <pavel@denx.de>
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
In-Reply-To: <20130829213249.GA25940@amd.pavel.ucw.cz>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
	 <87eh9dzg00.fsf@mid.deneb.enyo.de>
	 <1377734505.19568.39.camel@linux-s257.site>
	 <20130829213249.GA25940@amd.pavel.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Aug 2013 06:30:17 +0800
Message-ID: <1377815417.7080.28.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2013-08-29 於 23:32 +0200，Pavel Machek 提到：
> Hi!
> 
> > > >    - Bootloader store the public key to EFI boottime variable by itself
> > > >    - Bootloader put The private key to S4SignKey EFI variable for forward to
> > > >      kernel.
> > > 
> > > Is the UEFI NVRAM really suited for such regular updates?
> > > 
> > 
> > Yes, Matthew raised this concern at before. I modified patch to load
> > private key in efi stub kernel, before ExitBootServices(), that means we
> > don't need generate key-pair at every system boot. So, the above
> > procedure of efi bootloader will only run one time. 
> > 
> > User can enable SNAPSHOT_REGEN_KEYS kernel config to notify efi
> > booloader regenerate key-pair for every S4 to improve security if he
> > want. So, the key-pair re-generate procedure will only launched when S4
> > resume, not every system boot.
> 
> How many writes can UEFI NVRAM survive? (Is it NOR?)

Currently doesn't have enough information for normal. Yes, I don't know.

> 
> "every S4 resume" may be approximately "every boot" for some users...
> 									Pavel

Yes, it's possible.

So, this option will be disabled by default. Default will only generate
one key-pair for every hibernate.
If "re-generate key-pair for every S4" is still hurt lift of UEFI NVRAM
too much, then another thinking for re-generate key-pair are:
 
 + Re-generate key-pair after a number of hibernates.
   e.g. after 5, 10, 20... times
or
 + Random re-generate key-pair?


On the other hand...
In current design, GenS4Key EFI variable could be write by userland
hibernate tool, kernel will respect GenS4Key value from userland when
hibernate launch. So, userland can tell bootloader to lunch the key-pair
regeneration procedure.


Thanks a lot!
Joey LEe

