Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab3IZOsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:48:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56084 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab3IZOsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:48:08 -0400
Date: Thu, 26 Sep 2013 16:48:00 +0200 (CEST)
From: Jiri Kosina <jiri.kosina@suse.com>
X-X-Sender: jkosina@pobox.suse.cz
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
        David Howells <dhowells@redhat.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        opensuse-kernel@opensuse.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate
 snapshot
In-Reply-To: <1380206654.18835.56.camel@dabdike.int.hansenpartnership.com>
Message-ID: <alpine.LNX.2.00.1309261646150.18703@pobox.suse.cz>
References: <Pine.LNX.4.44L0.1309251723001.26508-100000@netrider.rowland.org>   <1380147414.18835.36.camel@dabdike.int.hansenpartnership.com>   <20130926002730.GA26857@amd.pavel.ucw.cz>  <1380162771.18835.47.camel@dabdike.int.hansenpartnership.com> 
 <alpine.LNX.2.00.1309260819490.18703@pobox.suse.cz> <1380206654.18835.56.camel@dabdike.int.hansenpartnership.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Sep 2013, James Bottomley wrote:

> > could you please describe the exact scenario you think that the symmetric 
> > keys aproach doesn't protect against, while the assymetric key aproach 
> > does?
> > 
> > The crucial points, which I believe make the symmetric key aproach work 
> > (and I feel quite embarassed by the fact that I haven't realized this 
> > initially when coming up with the assymetric keys aproach) are:
> > 
> > - the kernel that is performing the actual resumption is trusted in the 
> >   secure boot model, i.e. you trust it to perform proper verification
> > 
> > - potentially malicious userspace (which is what we are protecting against 
> >   -- malicious root creating fake hibernation image and issuing reboot) 
> >   doesn't have access to the symmetric key
> 
> OK, so the scheme is to keep a symmetric key in BS that is passed into
> the kernel each time (effectively a secret key) for signing and
> validation?

Exactly.

> The only two problems I see are
> 
>      1. The key isn't generational (any compromise obtains it).  This
>         can be fixed by using a set of keys generated on each boot and
>         passing in both K_{N-1} and K_N

I think this could be easily made optional, leaving the user with choice 
of faster or "safer" boot.

>      2. No external agency other than the next kernel can do the
>         validation since the validating key has to be secret

This is true, but as you said, the relevance of this seems to be rather 
questionable.

-- 
Jiri Kosina
SUSE Labs
