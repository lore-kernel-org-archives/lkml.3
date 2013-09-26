Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab3IZO4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:56:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56529 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416Ab3IZO4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:56:35 -0400
Date: Thu, 26 Sep 2013 16:56:33 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: Jiri Kosina <jiri.kosina@suse.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
        David Howells <dhowells@redhat.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        opensuse-kernel@opensuse.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Josh Boyer <jwboyer@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate snapshot
Message-ID: <20130926145633.GA572@suse.cz>
References: <Pine.LNX.4.44L0.1309251723001.26508-100000@netrider.rowland.org>
 <1380147414.18835.36.camel@dabdike.int.hansenpartnership.com>
 <20130926002730.GA26857@amd.pavel.ucw.cz>
 <1380162771.18835.47.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1309260819490.18703@pobox.suse.cz>
 <1380206654.18835.56.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1309261646150.18703@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1309261646150.18703@pobox.suse.cz>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 04:48:00PM +0200, Jiri Kosina wrote:

> > The only two problems I see are
> > 
> >      1. The key isn't generational (any compromise obtains it).  This
> >         can be fixed by using a set of keys generated on each boot and
> >         passing in both K_{N-1} and K_N
> 
> I think this could be easily made optional, leaving the user with choice 
> of faster or "safer" boot.

Ideally, the key should be regenerated on each true reboot and kept the
same if it is just a resume. Unfortunately, I don't see a way to
distinguish those before we call ExitBootServices().

The reasoning behind that is that in the case of a kernel compromise, a
suspended-and-resumed kernel will still be compromised, so there is no
value in passing it a new key. A freshly booted kernel, though, should
get a new key, exactly because the attacker could have obtained a key
from the previous, compromised one.

This speeds up the ususal suspend-and-resume cycle, but provides full
security once the user performs a full reboot.

The question that remains is how to tell in advance.

> >      2. No external agency other than the next kernel can do the
> >         validation since the validating key has to be secret
> 
> This is true, but as you said, the relevance of this seems to be rather 
> questionable.

Indeed, it's hard to imagine a scenario that is also valid within the
secure boot threat model.

-- 
Vojtech Pavlik
Director SUSE Labs
