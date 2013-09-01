Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab3IAKlk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 06:41:40 -0400
Received: from ka.mail.enyo.de ([87.106.162.201]:37230 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757342Ab3IAKlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 06:41:37 -0400
From: Florian Weimer <fw@deneb.enyo.de>
To: joeyli <jlee@suse.com>
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
Subject: Re: [RFC PATCH 00/18 v3] Signature verification of hibernate snapshot
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
	<87eh9dzg00.fsf@mid.deneb.enyo.de>
	<1377734505.19568.39.camel@linux-s257.site>
Date: Sun, 01 Sep 2013 12:41:22 +0200
In-Reply-To: <1377734505.19568.39.camel@linux-s257.site> (joeyli's message of
	"Thu, 29 Aug 2013 08:01:45 +0800")
Message-ID: <87r4d8vn71.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* joeyli:

> Yes, Matthew raised this concern at before. I modified patch to load
> private key in efi stub kernel, before ExitBootServices(), that means we
> don't need generate key-pair at every system boot. So, the above
> procedure of efi bootloader will only run one time. 

But if you don't generate fresh keys on every boot, the persistent
keys are mor exposed to other UEFI applications.  Correct me if I'm
wrong, but I don't think UEFI variables are segregated between
different UEFI applications, so if anyone gets a generic UEFI variable
dumper (or setter) signed by the trusted key, this cryptographic
validation of hibernate snapshots is bypassable.
