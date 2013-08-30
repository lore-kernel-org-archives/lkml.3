Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab3H3XOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 19:14:45 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:58687 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab3H3XOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 19:14:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAFECyb-J4gTiAQkKVT8qt94Tk6-_jVdX=sNM7VkXkyvPdEeZFA@mail.gmail.com>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
 <1376090777-20090-13-git-send-email-roy.franz@linaro.org> <20130830133902.AEA7A3E102A@localhost>
 <CAFECyb-J4gTiAQkKVT8qt94Tk6-_jVdX=sNM7VkXkyvPdEeZFA@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 31 Aug 2013 00:14:22 +0100
X-Google-Sender-Auth: Ig2C0QPVPd7w-y9cjtUKtX8Cn8k
Message-ID: <CACxGe6tJyGDN5nTePuwcV_W44Fk+mku+V8EoOvPaos72mbKdEw@mail.gmail.com>
Subject: Re: [PATCH 12/16] Fix types in EFI calls to match EFI function definitions.
To: Roy Franz <roy.franz@linaro.org>
Cc: matt.fleming@intel.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Dave Martin <dave.martin@arm.com>, Mark Salter <msalter@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 12:12 AM, Roy Franz <roy.franz@linaro.org> wrote:
> On Fri, Aug 30, 2013 at 6:39 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> I think you need some description in the commit text about why the type
>> of chunksize is changing. It's not clear why you're making this change.
>> It is a bug fix?
>
> The type was changed to match the EFI_FILE_PROTOCOL specification -
> chunk size is
> defined as a native width unsigned integer.  So yes, this is a bug in
> that this is wrong for
> ia32, since that really should be a u32 in that case.
> Since the x86 wrappers break type checking by the compiler these types
> were never checked at compile time
> before.  chunksize is the the only change that isn't a cast to a type
> of void pointer.
>
> I can break this change out as a separate patch if desired.

I don't think it needs to be in a separate patch, but it does need to
be described in the patch description.

g.
