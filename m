Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab3IIFBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 01:01:54 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:48649 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab3IIFBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 01:01:53 -0400
Date: Mon, 9 Sep 2013 07:01:47 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Peng Tao <tao.peng@emc.com>, Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH] staging: Disable lustre file system for MIPS, SH, and
 XTENSA
Message-ID: <20130909050147.GA3899@osiris>
References: <1378688580-11935-1-git-send-email-linux@roeck-us.net>
 <20130909015945.GA4029@kroah.com>
 <522D3153.5000102@roeck-us.net>
 <20130909023152.GA5329@kroah.com>
 <522D32F6.4020705@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522D32F6.4020705@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090904-5024-0000-0000-000007251BDC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 08, 2013 at 07:31:18PM -0700, Guenter Roeck wrote:
> On 09/08/2013 07:31 PM, Greg Kroah-Hartman wrote:
> >On Sun, Sep 08, 2013 at 07:24:19PM -0700, Guenter Roeck wrote:
> >>On 09/08/2013 06:59 PM, Greg Kroah-Hartman wrote:
> >>>On Sun, Sep 08, 2013 at 06:03:00PM -0700, Guenter Roeck wrote:
> >>>>mips allmodconfig fails with
> >>>>
> >>>>ERROR: "copy_from_user_page" [drivers/staging/lustre/lustre/libcfs/libcfs.ko]
> >>>>undefined!
> >>>>
> >>>>which is due to LUSTRE using copy_from_user_page which is not exported by any
> >>>>architecture.
> >>>
> >>>Any, or just these arches?
> >>>
> >>Other architectures implement it as define as far as I can see.
> >
> >Then why would it be a problem?
> >
> It isn't a problem for those other architectures. Mostly it is mapped to functions like memcpy().
> 
> Guenter
> 
> >>>>Unfortunately, LUSTRE can only be built as module, so there is no
> >>>>easy fix.
> >>>
> >>>Can't we just export the functions for those arches?  Surely lutre
> >>>isn't the first/only driver that needs this?
> >>>
> >>That would be another option.
> >>
> >>Actually, turns out Geert submitted a patch to do this for mips already, and Ralf applied it:
> >>
> >>https://lkml.org/lkml/2013/9/5/111
> >>
> >>So please forget this patch. If sh/xtensa actually need it, we can do the same there.
> >
> >Sounds good to me, consider it forgotten :)
> >
> >greg k-h

The proper "fix" seems to be to get rid of this new usage of 
copy_from_user_page() in lustre.
The code in question is nothing but a copy of __access_remote_vm()
from mm/memory.c...

