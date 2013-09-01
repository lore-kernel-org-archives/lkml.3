Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab3IAQqq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 12:46:46 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60339 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab3IAQqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 12:46:43 -0400
Date: Sun, 1 Sep 2013 17:46:37 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: joeyli <jlee@suse.com>, linux-kernel@vger.kernel.org,
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
Subject: Re: [RFC PATCH 00/18 v3] Signature verification of hibernate
 snapshot
Message-ID: <20130901164637.GA2409@srcf.ucam.org>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <87eh9dzg00.fsf@mid.deneb.enyo.de>
 <1377734505.19568.39.camel@linux-s257.site>
 <87r4d8vn71.fsf@mid.deneb.enyo.de>
 <20130901160429.GA1375@srcf.ucam.org>
 <87vc2ksdfa.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vc2ksdfa.fsf@mid.deneb.enyo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 01, 2013 at 06:40:41PM +0200, Florian Weimer wrote:
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
 
A signed application that permits the modification of arbitrary boot 
services variables *is* malicious. No implementation is designed to be 
safe in that scenario. Why bother with modifying encryption keys when 
you can just modify MOK instead?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
