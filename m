Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab3HYQ0j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 12:26:39 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49761 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab3HYQ0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 12:26:36 -0400
Date: Sun, 25 Aug 2013 17:26:19 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        opensuse-kernel@opensuse.org, David Howells <dhowells@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
        Matthew Garrett <mjg@redhat.com>, "Lee, Chun-Yi" <jlee@suse.com>
Subject: Re: [PATCH 10/18] efi: Enable secure boot lockdown automatically
 when enabled in firmware
Message-ID: <20130825162618.GA20297@srcf.ucam.org>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <1377169317-5959-11-git-send-email-jlee@suse.com>
 <20130825162243.GG5171@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130825162243.GG5171@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 25, 2013 at 06:22:43PM +0200, Pavel Machek wrote:
> On Thu 2013-08-22 19:01:49, Lee, Chun-Yi wrote:
> > From: Matthew Garrett <mjg@redhat.com>
> > 
> > The firmware has a set of flags that indicate whether secure boot is enabled
> > and enforcing. Use them to indicate whether the kernel should lock itself
> > down.  We also indicate the machine is in secure boot mode by adding the
> > EFI_SECURE_BOOT bit for use with efi_enabled.
> 
> > +	status = efi_call_phys5(sys_table->runtime->get_variable,
> > +				L"SecureBoot", &var_guid, NULL, &datasize, &sb);
> 
> What is this L"..." thing?

http://en.wikipedia.org/wiki/C_syntax#Wide_character_strings
-- 
Matthew Garrett | mjg59@srcf.ucam.org
