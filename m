Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab3BFSS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 13:18:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107Ab3BFSS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 13:18:58 -0500
Date: Wed, 6 Feb 2013 13:18:46 -0500
From: Kyle McMartin <kmcmarti@redhat.com>
To: Stephan Mueller <stephan.mueller@atsec.com>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        rusty@rustcorp.com.au, jstancek@redhat.com,
        herbert@gondor.hengli.com.au
Subject: Re: [RFC PATCH] fips: check whether a module registering an alg or
 template is signed
Message-ID: <20130206181845.GL3751@redacted.bos.redhat.com>
References: <20130122184357.GD6538@redacted.bos.redhat.com>
 <8615.1358940375@warthog.procyon.org.uk>
 <50FFFF48.6020608@atsec.com>
 <20130124190610.GI6538@redacted.bos.redhat.com>
 <5102781D.9000408@atsec.com>
 <20130205225830.GH3751@redacted.bos.redhat.com>
 <51120E26.7030400@atsec.com>
 <20130206161557.GJ3751@redacted.bos.redhat.com>
 <511296C9.8010102@atsec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511296C9.8010102@atsec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 06:45:45PM +0100, Stephan Mueller wrote:
> Unfortunately there has already something terrible happened: an
> additional piece of code loaded into the FIPS 140-2 module could not be
> loaded because a self test failed. This is a terrible accident in FIPS
> 140-2 speak. :-)
> 
> That means, the FIPS 140-2 module, aka kernel crypto API must become
> unavailable. As one self test failed, the entire module must become
> unavailable.
> 
> I am sorry, but there is no way around it. Just to quote the relevant
> part from the FIPS 140-2 specification, section 4.9:
> 
> If a cryptographic module fails a self-test, the module shall enter an
> error state and output an error indicator
> via the status output interface. The cryptographic module shall not
> perform any cryptographic operations
> while in an error state. All data output via the data output interface
> shall be inhibited when an error state
> exists.
> 

OK. If Herbert and Rusty are ok with this, I'll send an additional patch
moving the panic which should satisfy this requirement.

> 
> ==> the signature test we are discussing here is one of these self
> tests, in particular a conditional self test defined in section 4.9.2 of
> the FIPS 140-2 standard.
> 
> > necessary, I just didn't think it was. If Herbert doesn't object to this
> > patch, I'd move the panic from kernel/module.c to here.
> 
> I am perfectly happy with the move of the code.
> 

regards, Kyle
