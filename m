Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab3I3PGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:06:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18121 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab3I3PGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:06:04 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-9d-5249935bf183
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: David Laight <David.Laight@aculab.com>
Cc: Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/8xx: tqm8xx: fix incorrect placement of __initdata
 tag
Date: Mon, 30 Sep 2013 17:05:51 +0200
Message-id: <9412116.FMJVEO7gkK@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <AE90C24D6B3A694183C094C60CF0A2F6026B736B@saturn3.aculab.com>
References: <1589399.KSlGuZSdd2@amdc1032>
 <AE90C24D6B3A694183C094C60CF0A2F6026B736B@saturn3.aculab.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=Windows-1252
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t9jQd3oyZ5BBvPWCVrsWLqZyeJs0xt2
	i8u75rBZ/P7+j9Vi96d+JouZm/8xObB59M+ewubR86aF1WPTp0nsHudnLGT06NuyitHj8ya5
	ALYoLpuU1JzMstQifbsEroyjL7vZCuZzVVyfdJK1gXEKRxcjJ4eEgInEnAnL2CBsMYkL99YD
	2VwcQgLTGSV+LJ7EAuG0MEkc7TrKBFLFJmAlMbF9FSOILSKgJXF95zNmkCJmgf2MEktfzmEB
	SQgLhEqsa5nHDGKzCKhKfHryHMzmFdCUeLtrLdg6UQFPiU+TlgLFOTg4Bbwkpn2RAwkLCWRK
	bJ24jg2iXFDix+R7YCOZBeQl9u2fygph60l8/HObcQKjwCwkZbOQlM1CUraAkXkVo2hqQXJB
	cVJ6rpFecWJucWleul5yfu4mRnCYP5PewbiqweIQowAHoxIPr0G9Z5AQa2JZcWXuIUYJDmYl
	Ed7XE4BCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+2WgcKCaQnlqRmp6YWpBbBZJk4OKUaGAUf
	2f9s3rdOLoTt36vWs8dDzz5fpCkfPO/UU8fSU0JTTzJ/y/nAe+P1EqXS68KFE9PmbLxsE1a1
	QePr1qcPvbs0e5+Uz/tZvOhU5RKhFpsMvlrFuOAogf5IZ5/29E+LcwLdq0JYXUNms7/7NO/m
	TbaNYn1ixZpz3H7pnQ2+XVOolfJnzlbzaUosxRmJhlrMRcWJAFCl7K1vAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 30, 2013 03:20:29 PM David Laight wrote:
> > __initdata tag should be placed between the variable name and equal
> > sign for the variable to be placed in the intended .init.data section.
> ...
> > -static struct __initdata cpm_pin tqm8xx_pins[] = {
> > +static struct cpm_pin tqm8xx_pins[] __initdata = {
> 
> As far as gcc is concerned it can go almost anywhere before the '=',
> even before the 'static'.
> Splitting 'struct cpm_pin' does seem an odd choice.

It is not only an odd choice, it just doesn't work as it should in
the practice (as tested with gcc-4.6.3 from Ubuntu 12.04).

> The Linux coding standards might suggest a location.
> I'd have thought that either before or after the 'static' would be best
> (ie as a storage class qualifier).

The majority of the kernel code uses __initdata before equal sign
and the __initdata documentation in <linux/init.h> recommends such
usage:

"
 * For initialized data:
 * You should insert __initdata or __initconst between the variable name
 * and equal sign followed by value, e.g.:
 *
 * static int init_variable __initdata = 0;
 * static const char linux_logo[] __initconst = { 0x32, 0x36, ... };
"

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

