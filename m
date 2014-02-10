Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaBJJws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 04:52:48 -0500
Received: from mail.wdtv.com ([66.118.69.84]:46427 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbaBJJwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 04:52:46 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: make oldfonfig broken.
Date: Mon, 10 Feb 2014 04:52:34 -0500
Cc: Ken Moffat <zarniwhoop@ntlworld.com>, linux-kernel@vger.kernel.org
References: <1391971686-9517-1-git-send-email-richard@nod.at> <201402092332.32439.gheskett@wdtv.com> <52F85D2F.6010501@infradead.org>
In-Reply-To: <52F85D2F.6010501@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201402100452.34646.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 February 2014, Randy Dunlap wrote:
[...]
>>>>> Gene, I want to make sure where you are saying the problem is.
>>>>> Is it going directly from 3.019 to 3.8.2, with no intervening kernel
>>>>> versions?
>>>> 
>>>> No, one intermediate step in this case.
>>>> 
>>>> I started with 3.0.19, which was fine, took that one to 3.2.40, and
>>>> that one to 3.8.2 because I don't have anything between those here.
>>>> Not exactly a step by step.
>>> 
>>> and when you go from one kernel version to the next, do you use
>>> 
>>> $ make oldconfig
>>> and answer all of its questions, or do you use
>> 
>> I generally answer all its questions, or take the default by hitting
>> enter, but I do read all its questions.
>> 
>>> $ yes '' | make oldconfig
>> 
>> Never done that in all these years.
>> 
>>> or some other variant?  (I guess in your super build script.)
>> 
>> This is long before my "super script" gets fired off.
>> 
>> And that part is actually working well, run it as root, do a
>> grub-update and reboot.
>> 
>> Cheers, Gene
>
>You need to have a Kconfig symbol named DVB_CORE enabled.
>
>In 3.8.2 (and likely previously, but not in 3.2.40),
>DVB_CORE depends on having both MEDIA_SUPPORT and
>MEDIA_DIGITAL_TV_SUPPORT enabled.  Your .confile file  has MEDIA_SUPPORT
>enabled but not
>MEDIA_DIGITAL_TV_SUPPORT.
>
>In your 3.2.40 kernel source tree, just edit your .config file and delete
>the line that says:
># CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
>
>then run [1]
>$ make oldconfig
>and it will ask you how to set the Kconfig symbol.  Tell it 'y'.
>
>and if you can find this line in your .config file:
>CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
>
>delete it. Run 'make oldconfig' again if you did so at [1] above.
>For this Kconfig question:
>  Autoselect tuners and i2c modules to build (MEDIA_SUBDRV_AUTOSELECT),
>answer N.
>Then you can select all of the tuners and frontends that you want.
>There are LOTS of them to choose from.
>
>IIRC, this all happened because someone decided that they could make the
>AUTOSELECT driver feature Better!  ugh.
>
>Good luck. Let me know if you need more guidance.

Printed. That sounds as if I ought to be able to do it, which I will take a 
shot at tomorrow.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

NOTICE: Will pay 100 USD for an HP-4815A defective but
complete probe assembly.

