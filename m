Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab3FEUAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:00:00 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:49790 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757276Ab3FET76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 15:59:58 -0400
Date: Wed, 5 Jun 2013 20:59:53 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "Fleming, Matt" <matt.fleming@intel.com>, joeyli <jlee@suse.com>,
        "rja@sgi.com" <rja@sgi.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "bp@alien8.de" <bp@alien8.de>, "jkosina@suse.cz" <jkosina@suse.cz>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "oneukum@suse.de" <oneukum@suse.de>
Subject: Re: [PATCH] Modify UEFI anti-bricking code
Message-ID: <20130605195953.GD30420@console-pimps.org>
References: <1370117180-1712-1-git-send-email-matthew.garrett@nebula.com>
 <1370276021.30695.4.camel@linux-s257.site>
 <1370277079.6315.14.camel@x230.lan>
 <1370316933.30695.7.camel@linux-s257.site>
 <CAL01qptzxe5L6Vq+nBZLq+bQNxbe_i_2OdKMNJGZQDfMihaHOw@mail.gmail.com>
 <1370444007.6315.32.camel@x230.lan>
 <20130605155904.GC30420@console-pimps.org>
 <1370448519.6315.36.camel@x230.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370448519.6315.36.camel@x230.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Jun, at 04:08:39PM, Matthew Garrett wrote:
> On Wed, 2013-06-05 at 16:59 +0100, Matt Fleming wrote:
> 
> > +	/* clean DUMMY object */
> > +	efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID, 0, 0, NULL);
> 
> Hm. Actually, is that going to work? From the spec:
> 
> If a preexisting variable is rewritten with different attributes,
> SetVariable()shall not modify the variable and shall return
> EFI_INVALID_PARAMETER. 
> 
> So I think we probably need to fix the attributes to NV|RT|BS for both
> this call and the one in query_variable_store. We should probably also
> only do the workaround if the NV bit is set in the original query.

Yeah, that looks wrong.

Joey, care to resend an updated patch?

-- 
Matt Fleming, Intel Open Source Technology Center
