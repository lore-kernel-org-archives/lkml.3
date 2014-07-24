Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759630AbaGXRhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 13:37:51 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:37768 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758881AbaGXRhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 13:37:50 -0400
Date: Fri, 25 Jul 2014 01:36:13 +0800
From: Wang YanQing <udknight@gmail.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jingoo Han <jg1.han@samsung.com>, David Fries <David@Fries.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pavel@ucw.cz
Subject: Re: [PATCH v2] video: fbdev: uvesafb.c:  Added additional error
 checking
Message-ID: <20140724173613.GA2203@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Jingoo Han <jg1.han@samsung.com>, David Fries <David@Fries.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joe Perches <joe@perches.com>, linux-fbdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, pavel@ucw.cz
References: <1406150427-26077-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406150427-26077-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 11:20:27PM +0200, Rickard Strandqvist wrote:
> Variable was assigned a value that is never used.
> Now the variable is used, and the function returns if a call to
> uvesafb_exec() returns a error.

Because the only user of uvesafb_vbe_getpmi in uvesafb.c
don't check its return value, it should do the check indeed,
so maybe below change is better:

-       if ((task->t.regs.eax & 0xffff) != 0x4f || task->t.regs.es < 0xc000) {
+       if (err || (task->t.regs.eax & 0xffff) != 0x4f || task->t.regs.es < 0xc000) {
                par->pmi_setpal = par->ypan = 0;
        }

Or we check uvesafb_vbe_getpmi's return value, then the code will looks like below:

if (uvesafb_vbe_getpmi(task, par))
    par->pmi_setpal = par->ypan = 0;


Add cc:pavel@ucw.cz, you should cc all the people who replied your patch 
in later patch version.

Thanks.
