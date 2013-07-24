Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab3GXRXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:23:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54721 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751585Ab3GXRXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:23:19 -0400
Message-ID: <1374686598.18818.18.camel@joe-AO722>
Subject: Re: [PATCH] APEI/ERST: Fix error message formatting
From: Joe Perches <joe@perches.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>, Kees Cook <keescook@chromium.org>,
        Tony Luck <tony.luck@intel.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org
Date: Wed, 24 Jul 2013 10:23:18 -0700
In-Reply-To: <20130724171347.GB29756@naverao1-tp.watson.ibm.com>
References: <1374526866-6813-1-git-send-email-bp@alien8.de>
	 <20130724171347.GB29756@naverao1-tp.watson.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-24 at 22:43 +0530, Naveen N. Rao wrote:
> On 2013/07/22 11:01PM, Borislav Petkov wrote:
> > From: Borislav Petkov <bp@suse.de>
> > 
> > [    5.525861] ERST: Can not request iomem region <0x        c7eff000-0x        c7f00000> for ERST.
> > 
> > This needs to have leading zeroes. Make it so.

Why does it need leading zeros?

> While looking at this, I noticed that we seem to be using varying field
> widths in our APEI code:
> - einj.c has two instances using %#010llx.
> - apei-base.c uses widths of 10 (4 bytes) and 6 (2 bytes).
> 
> Not sure if these are intentional and those fields truly aren't 64-bit
> (as suggested by the usage of long long int).

I suggest using "0x%llx" everywhere unless there's a
compelling reason like columnar alignment for them.


