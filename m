Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab3BBTnf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 14:43:35 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:43207 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758072Ab3BBTnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 14:43:33 -0500
Message-ID: <1359834211.2831.5.camel@joe-AO722>
Subject: Re: Question about printking
From: Joe Perches <joe@perches.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: gregkh <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        kernelnewbies <kernelnewbies@kernelnewbies.org>,
        kernel-janitors@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Date: Sat, 02 Feb 2013 11:43:31 -0800
In-Reply-To: <CALF0-+V-8m1TwnM0MUbNCncnECF_r_FVcyu_Duu0tqcsPoFR5A@mail.gmail.com>
References: <CALF0-+XX27u4rmpe8RHiy5DsbHvoYP9DWQts+rTRfEvPQG4s8Q@mail.gmail.com>
	 <CALF0-+V-8m1TwnM0MUbNCncnECF_r_FVcyu_Duu0tqcsPoFR5A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-02-02 at 16:30 -0300, Ezequiel Garcia wrote:
> ptr = kmalloc(sizeof(foo));
> if (!ptr) {
>         pr_err("Cannot allocate memory for foo\n");
>         return -ENOMEM;
> }
> His argue against it was that kmalloc already takes care of reporting/printking
> a good deal of interesting information when this happens.

> Can someone expand a bit on this whole idea? (of abuse of printing,
> or futility of printing).

k.alloc() takes a GFP_ flag as an arg.

One of those GFP flags is __GFP_NOWARN.

For all failed allocs without GFP_NOWARN
a message is emitted and a dump_stack is
done.

(see: mm/page_alloc.c warn_alloc_failed())

So, most all of these printks after
k.alloc()'s are not necessary.


