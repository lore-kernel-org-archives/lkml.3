Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab3H2AD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 20:03:27 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:58774 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab3H2ADZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 20:03:25 -0400
Subject: Re: [RFC PATCH 00/18 v3] Signature verification of hibernate
 snapshot
From: joeyli <jlee@suse.com>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, opensuse-kernel@opensuse.org,
        David Howells <dhowells@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
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
In-Reply-To: <87eh9dzg00.fsf@mid.deneb.enyo.de>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
	 <87eh9dzg00.fsf@mid.deneb.enyo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Aug 2013 08:01:45 +0800
Message-ID: <1377734505.19568.39.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian, 

Thanks for your response.

於 三，2013-08-28 於 23:01 +0200，Florian Weimer 提到：
> * Chun-Yi Lee:
> 
> >  + EFI bootloader must generate RSA key-pair when system boot:

I should add more information on this sentence for mention need GenS4Key
runtime variable then re-generate key-pair.

Thanks!

> >    - Bootloader store the public key to EFI boottime variable by itself
> >    - Bootloader put The private key to S4SignKey EFI variable for forward to
> >      kernel.
> 
> Is the UEFI NVRAM really suited for such regular updates?
> 

Yes, Matthew raised this concern at before. I modified patch to load
private key in efi stub kernel, before ExitBootServices(), that means we
don't need generate key-pair at every system boot. So, the above
procedure of efi bootloader will only run one time. 

User can enable SNAPSHOT_REGEN_KEYS kernel config to notify efi
booloader regenerate key-pair for every S4 to improve security if he
want. So, the key-pair re-generate procedure will only launched when S4
resume, not every system boot.


Thanks a lot!
Joey Lee

