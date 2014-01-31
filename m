Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbaAaOXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 09:23:35 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54167 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191AbaAaOXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 09:23:33 -0500
Date: Fri, 31 Jan 2014 15:23:18 +0100
From: Borislav Petkov <bp@alien8.de>
To: Russ Anderson <rja@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alex Thorlton <athorlton@sgi.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [BUG] Linux 3.14 fails to boot with new EFI changes
Message-ID: <20140131142318.GC21873@pd.tnic>
References: <20140127222129.GK6839@pd.tnic>
 <20140128110552.GA815@pd.tnic>
 <20140128200754.GZ18196@sgi.com>
 <20140128225905.GN815@pd.tnic>
 <20140128234036.GB18196@sgi.com>
 <20140129141822.GC24887@pd.tnic>
 <20140130221950.GJ3105@sgi.com>
 <52EAD0F2.7090101@zytor.com>
 <20140131100722.GA21873@pd.tnic>
 <20140131140220.GC22498@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140131140220.GC22498@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 08:02:21AM -0600, Russ Anderson wrote:
> I'm not sure what you are asking for. We had a reliable
> way to boot before the recent patch broke it. (commit
> d2f7cbe7b26a74dbbbf8f325b2a6fd01bc34032c)

So we should stop any further development just because your machines did
boot nicely before that. What about the other machines and kexec we're
fixing with the work above? Jeez...

Ok, let me give it in a more detailed fashion for ya:

1. uv_bios_init remaps the UV systab table which is at physical address
efi.uv_systab

2. Then, it copies it into uv_systab. The purpose of this is for you to
be able to call the uv_systab.function callback and thus call into your
firmware.

3. Now, uv_systab.function points to a region of code which contains
your BIOS callback, and that pointer is the entry point into that
function.

And now my question:

How can I reliably find out which region contains that
uv_systab.function call?

I need it so that I can map it in the EFI page table and you can
continue to call that function and you can get back to your reliable way
to boot.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
