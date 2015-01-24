Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbbAXVli (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 16:41:38 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:56843 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbbAXVle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 16:41:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: ux500: Move struct
Date: Sat, 24 Jan 2015 22:40:53 +0100
Message-ID: <1749867.D7qte28FRP@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKXHbyOhD5_cHRp02AuhcYFR5m8nBvWzdsygUdw689LrS9R67g@mail.gmail.com>
References: <1421881782-23716-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <20150122074458.GL22024@x1> <CAKXHbyOhD5_cHRp02AuhcYFR5m8nBvWzdsygUdw689LrS9R67g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:GXfWQ8CWh7zZu0bcMQiAEyqshFwuSQtZpRyW9eUzIXvKTJK0/Jf
 iJTHwG79ZfZgHuCNXeTPMrGfuzSH5EfshXHFA7Rn43T0peN8nRd6FTaDIBzCb2W091IfjT1
 +ian882IpXa+r7WV6uJsWWfL5R9A7mxEKZcQqaeGTD40TsS35RfC60pCv5hgS3rmSFbqv8i
 SGFLHVFgyOZoG/x/VYPsQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 January 2015 18:33:00 Rickard Strandqvist wrote:
> 2015-01-22 8:44 GMT+01:00 Lee Jones <lee.jones@linaro.org>:
> >
> > Are you sure a struct is required at all now?  It only contains a
> > single bool after all.
> 
> 
> Hi Lee
> 
> Okay, I will gladly remove ab8500_ext_regulator_cfg completely.
> And I will try to update the comments, but since I'm not so familiar
> with what this code was meant to do it is a little more difficult.
> 

Try to take small steps then: See if there is something in this code
that is either never called, or data structures that are only
written but never read, or pointers that are verifiably always 
NULL, then eliminate one piece of the code at a time, with a patch
that explains what you found.

Try to make sure everything still builds after each patch, and note
that this was not the case with your first patch, though it would have
worked in the reverse order.

I suspect the best way forward is to actually move all of
ab8500_regulator_plat_data and whatever it references into
drivers/regulator/ab8500-ext.c because there now is only one
remaining instance of that. After this move, you can delete
a lot of code in arch/arm/mach-ux500 and possibly move all of
include/linux/regulator/ab8500.h into drivers/regulator/ab8500-ext.c
as well.

	Arnd
