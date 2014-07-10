Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaGJJl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:41:28 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:43984 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaGJJlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:41:25 -0400
X-Auth-Info: Zsd0DrGAYtwolm4U3hUo6QAGbV4AMXCt1axUsAkm0rA=
From: Marek Vasut <marex@denx.de>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v1 1/5] seq_file: provide an analogue of print_hex_dump()
Date: Thu, 10 Jul 2014 09:58:02 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>, linux390@de.ibm.com,
        Alexander Viro <viro@zeniv.linux.org.uk>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com> <201407092239.30561.marex@denx.de> <1404940868.932.168.camel@joe-AO725>
In-Reply-To: <1404940868.932.168.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201407100958.02218.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 09, 2014 at 11:21:08 PM, Joe Perches wrote:
> On Wed, 2014-07-09 at 22:39 +0200, Marek Vasut wrote:
> > The above function looks like almost verbatim copy of print_hex_dump().
> > The only difference I can spot is that it's calling seq_printf() instead
> > of printk(). Can you not instead generalize print_hex_dump() and based
> > on it's invocation, make it call either seq_printf() or printk() ?
> 
> How do you propose doing that given any seq_<foo> call
> requires a struct seq_file * and print_hex_dump needs
> a KERN_<LEVEL>.

I can imagine a rather nasty way, I can't say I would like it myself tho. The 
general idea would be to pull out the entire switch {} statement into a separate 
functions , one for printk() and one for seq_printf() cases. Then, have a 
generic do_hex_dump() call which would take as an argument a pointer to either 
of those functions and a void * to either the seq_file or level . Finally, there 
would have to be a wrapper to call the do_hex_dump() with the correct function 
pointer and it's associated arg.

Nasty? Yes ... Ineffective? Most likely.

> Is there an actual value to it?

Reducing the code duplication, but I wonder if there is a smarter solution than 
the horrid one above.

Best regards,
Marek Vasut
