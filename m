Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab3FFCZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 22:25:46 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:35500 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab3FFCZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 22:25:41 -0400
Subject: Re: [PATCH] Modify UEFI anti-bricking code
From: joeyli <jlee@suse.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        "Fleming, Matt" <matt.fleming@intel.com>, "rja@sgi.com" <rja@sgi.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "bp@alien8.de" <bp@alien8.de>, "jkosina@suse.cz" <jkosina@suse.cz>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "oneukum@suse.de" <oneukum@suse.de>
In-Reply-To: <1370448519.6315.36.camel@x230.lan>
References: <1370117180-1712-1-git-send-email-matthew.garrett@nebula.com>
	 <1370276021.30695.4.camel@linux-s257.site>
	 <1370277079.6315.14.camel@x230.lan>
	 <1370316933.30695.7.camel@linux-s257.site>
	 <CAL01qptzxe5L6Vq+nBZLq+bQNxbe_i_2OdKMNJGZQDfMihaHOw@mail.gmail.com>
	 <1370444007.6315.32.camel@x230.lan>
	 <20130605155904.GC30420@console-pimps.org>
	 <1370448519.6315.36.camel@x230.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Jun 2013 10:24:20 +0800
Message-ID: <1370485460.6523.30.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 三，2013-06-05 於 16:08 +0000，Matthew Garrett 提到：
> On Wed, 2013-06-05 at 16:59 +0100, Matt Fleming wrote:
> 
> > +	/* clean DUMMY object */
> > +	efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID, 0, 0, NULL);
> 
> Hm. Actually, is that going to work? From the spec:
> 

The patch I tested on OVMF, it can delete DUMMY object when system boot.

> If a preexisting variable is rewritten with different attributes,
> SetVariable()shall not modify the variable and shall return
> EFI_INVALID_PARAMETER. 
> 
> So I think we probably need to fix the attributes to NV|RT|BS for both
> this call and the one in query_variable_store. We should probably also
> only do the workaround if the NV bit is set in the original query.
> 
> -- 
> Matthew Garrett | mjg59@srcf.ucam.org

Yes, I think that more safe for fix the attributes.


Thanks a lot!
Joey Lee



