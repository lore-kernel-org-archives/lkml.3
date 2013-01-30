Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab3A3BBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:01:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab3A3BBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:01:09 -0500
Date: Tue, 29 Jan 2013 17:01:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Dan Carpenter'" <dan.carpenter@oracle.com>,
        "'Inki Dae'" <inki.dae@samsung.com>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] backlight: s6e63m0: report ->gamma_table_count
 correctly
Message-Id: <20130129170107.f27c1ed3.akpm@linux-foundation.org>
In-Reply-To: <00c601cdfaa2$c52d03c0$4f870b40$%han@samsung.com>
References: <20130124070524.GD5611@elgon.mountain>
	<00c601cdfaa2$c52d03c0$4f870b40$%han@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2013 11:22:06 +0900
Jingoo Han <jg1.han@samsung.com> wrote:

> On Thursday, January 24, 2013 10:45 PM, Dan Carpenter wrote
> 
> CC'ed Andrew Morton, Inki Dae.
> 
> > 
> > gamma_table has 3 arrays which each hold MAX_GAMMA_LEVEL pointers to
> > int.
> > 
> > The current code sets ->gamma_table_count to 6 on 64bit arches and to 3
> > on 32 bit arches.  It should be 3 on everything.
> 
> Actually, I don't know it is right.
> However, it is certain that this panel is currently used on 32 bit arches
> such as ARM SoCs.

I don't know what gamma_table_count is supposed to do.  The only place
it is used is in s6e63m0_sysfs_show_gamma_table().  That function
doesn't actually show the table - it just prints out gamme_table_count.
Why is that useful?

Ho hum, the patch is clearly correct - the array stores int*'s and the
sysfs file should display "3" for all architectures.  However I suspect
we could just remove the whole sysfs file and nobody would care...

