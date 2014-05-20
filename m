Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301AbaETFtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 01:49:00 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:43768 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaETFs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 01:48:59 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, x86@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Hedi Berriche <hedi@sgi.com>,
        Mike Travis <travis@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] printk: Use symbolic defines for console loglevels
In-Reply-To: Your message of "Mon, 19 May 2014 20:27:32 +0200."
             <1400524052-25625-1-git-send-email-bp@alien8.de>
From: Valdis.Kletnieks@vt.edu
References: <1400524052-25625-1-git-send-email-bp@alien8.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1400564682_1944P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 20 May 2014 01:44:42 -0400
Message-ID: <16681.1400564682@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1400564682_1944P
Content-Type: text/plain; charset=us-ascii

On Mon, 19 May 2014 20:27:32 +0200, Borislav Petkov said:
> From: Borislav Petkov <bp@suse.de>
>
> ... instead of naked numbers.
>
> Stuff in sysrq.c used to set it to 8 which is supposed to mean above
> default level so set it to DEBUG instead as we're terminating/killing
> all tasks and we want to be verbose there.
>
> There should be no functionality change resulting from this patch.

After a quick eyeballing, looks like it, except for:

> +++ b/arch/x86/kernel/head64.c
> @@ -172,7 +172,7 @@ asmlinkage __visible void __init x86_64_start_kernel(char
 * real_mode_data)
>  	 */
>  	load_ucode_bsp();
>
> -	if (console_loglevel == 10)
> +	if (console_loglevel >= CONSOLE_LOGLEVEL_DEBUG)
>  		early_printk("Kernel alive\n");

But this looks like a bugfix that changes the behavior for loglevels > 11.

Having said that, it's probably OK to not split the bugfix out to
a separate patch....

--==_Exmh_1400564682_1944P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU3rrygdmEQWDXROgAQKZ/w/9HQshZnmAROeU0BGtvtTzLs3ICW9h56yl
oRAjM7qsh5NpSKAzLZYFCrCL8ZYdZFcvV+Eb6vp0j2DIXW2YohIcuNXuvGSUEob8
I6HMOd5cRuoBygEDwnFWddAobUrb3ToQuKoI1R2sQL1dJYH8Ms1a6W5P+5VPTAFB
xE5So1XlhcWi/4SEXZoKQgWGmHdRVmpVlFw5ZNqEQe9nOuWmVxDUKbW9k6rGz0nc
A621k6A3hLBTzSVdVLKe5FfVqIpfTy2Fe2gGmRpACpc36mwdOn7R2qoUBUevVlVb
pTa2ZDcdtlW/CXM0OSEgGYE/ffR+sIYpXSNm99VpdKlnkv/njmJJ0YCBAGXm0slz
6dqpxpDZMAsvM6xmfTGQvZlkqGPwsHe0Xj2Cr6Afn3k8COzltFXeqg88NIKVe+n+
znFAr5P9N+2mZlLUJKwwzGS/jS8bjIQTgyaoD8zkxHaANLhxQf2MxsXiqHnPdRdb
1WV1fqtdTOjM+nciMzFQV/lustfi3Le39bICxs6bnhpQ2TQ9rdyMFVaQi2HpiGKe
Q04XG8F4xMDpcQ2U+BLYQDmgqOq/j98wrNfvIo02aN0MyHvtpifQdk0lENEzkPZZ
ZK3f8ua7TtdoD7JtifhnPMawkCVFU1gPMzyUsvcCRdDrxBuNkr0S/QMrfK64X5Zr
/fxDbQnLZEA=
=v3yI
-----END PGP SIGNATURE-----

--==_Exmh_1400564682_1944P--
