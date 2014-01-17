Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaAQQP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:15:26 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:36678 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbaAQQPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:15:16 -0500
X-Auth-Info: CdI9t6aW659ahluAZYKeMWDKP5PX6uTuZ0eapwq9vNM=
Date: Fri, 17 Jan 2014 17:15:13 +0100
From: Gerhard Sittig <gsi@denx.de>
To: Waibel Georg <Georg.Waibel@sensor-technik.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] iMX gpio: Allow reading back of pin status if
 configured as gpio output
Message-ID: <20140117161513.GC20094@book.gsilab.sittig.org>
References: <E1C9442006A9AE48A7A4B85E0D01C4D474F059@stwexdb.stww2k.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1C9442006A9AE48A7A4B85E0D01C4D474F059@stwexdb.stww2k.local>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 14:11 +0000, Waibel Georg wrote:
> 
> From cb384950a1153e856ec03109a5156e660a89bf6d Mon Sep 17 00:00:00 2001
> From: Georg Waibel <georg.waibel@sensor-technik.de>
> Date: Fri, 17 Jan 2014 14:51:38 +0100
> Subject: [PATCH 1/1] iMX gpio: Allow reading back of pin status if configured
>  as gpio output
> 
> Register PSR was used to read the pin status in the mxc_gpio driver. This
> register reflects the pin status if a pin is configured as gpio input.
> If a pin is configured as an gpio output register PSR is not updated and
> returns 0 instead of the actual pin status. Thus attempting to read back the
> status of an gpio output pin via PSR returns a wrong value.
> 
> Reading register DR instead of PSR fixes this issue:
> - If pin is gpio output: DR returns the value written to DR by software
> - If pin is gpio input: DR returns the value of register PSR und thus the
>   pin status

Got curious because of your specific wording.  In the output
case, does the DR value reflect what you drive to the pin, or
what the pin's status is?  Because this need not be identical in
the open collector case (or other "weak" scenarios like bus
keeper, and what else HW development came up with).

If DR always reflects the pin's status, then the patch would be
OK but the commit message would need an update.  If DR does not
appropriately reflect the pin's status, then the patch would be
an improvement (would fix the totem-pole case), but still would
be wrong or incomplete in the open-collector case.


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
