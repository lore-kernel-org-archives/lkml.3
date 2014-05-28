Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbaE1Ov7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 10:51:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918AbaE1Ov4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 10:51:56 -0400
Date: Wed, 28 May 2014 10:51:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Dave Young <dyoung@redhat.com>
Cc: "Fleming, Matt" <matt.fleming@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
Subject: Re: [PATCH] export efi.flags to sysfs
Message-ID: <20140528145140.GN14863@redhat.com>
References: <20140526083935.GA19682@dhcp-16-198.nay.redhat.com>
 <20140527030058.GB2372@darkstar.nay.redhat.com>
 <CAL01qpvqa-8u2MZ=8wE8gsiprFLbN4U3AbEX9+h7FuemXNR93Q@mail.gmail.com>
 <20140528020935.GB2820@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528020935.GB2820@darkstar.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 10:09:35AM +0800, Dave Young wrote:

[..]
> > I've only vaguely been following along with the other thread, so please
> > summarise everything again in your patch. Particularly, I need answers
> > to the following questions,
> > 
> >  - Are you trying to fix a kexec/kdump regression?
> 
> Somehow it is a regression.

Well, it is a *regression*. Previously kdump would work with
SGI UV machines as it used "noefi". Now kexec by default thinks that
efi is enabled and 1:1 mappings are in place and that does not work
with SGI UV machines.

So just providing --noefi is not enough. Somebody needs to automatically
figure out that this SGI machine does not contain 1:1 mapping and hence
need to fall back to old mode. --noefi is good for override.

Thanks
Vivek
