Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab3AXO7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 09:59:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890Ab3AXO7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 09:59:15 -0500
Date: Thu, 24 Jan 2013 09:59:07 -0500
From: Kyle McMartin <kmcmarti@redhat.com>
To: Stephan Mueller <stephan.mueller@atsec.com>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, jstancek@redhat.com
Subject: Re: [PATCH] MODSIGN: only panic in fips mode if sig_enforce is set
Message-ID: <20130124145907.GG6538@redacted.bos.redhat.com>
References: <20130122184357.GD6538@redacted.bos.redhat.com>
 <8615.1358940375@warthog.procyon.org.uk>
 <50FFFF48.6020608@atsec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FFFF48.6020608@atsec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 04:18:32PM +0100, Stephan Mueller wrote:
> 3. in the cipher initialization code of the crypto API (i.e. the one
> behind crypto_register_alg()), you check the signature check flag --
> panic the kernel when the flag shows that the signature check failed
> 
> This way you limit the panic on signature checks in FIPS mode to the
> crypto modules.
> 

I was hoping we could just do what we do for driver/staging and set a
flag in modpost for crypto modules, but it looks like since we have
crypto modules outside of crypto/ for things like aesni, that won't
work. Maybe that is a better choice, but it seems like an awful kludge.

--Kyle
