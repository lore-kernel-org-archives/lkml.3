Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab3C1NI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 09:08:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51242 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab3C1NI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 09:08:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] clocksource: Fix build in non-OF case
Date: Thu, 28 Mar 2013 13:08:22 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Rob Herring <robherring2@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Axel Lin <axel.lin@ingics.com>
References: <1364473805-773-1-git-send-email-broonie@opensource.wolfsonmicro.com> <201303281239.46639.arnd@arndb.de> <20130328125513.GY18316@opensource.wolfsonmicro.com>
In-Reply-To: <20130328125513.GY18316@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303281308.22738.arnd@arndb.de>
X-Provags-ID: V02:K0:QLBdArHAu7r9n8Henbk57p1fBtMQWLqAcdj50lfKPeN
 w7lDwWXA6o+2BwK2hDdRQFQu2QObx3HFPtRR0qDGYielnAYDFD
 6/MiRpOrow26J3i/gniCndOcrS6uTH/Md5YzCV9+uo86QIi/Uv
 TYv4A+Xmwo15gGF8T4I4nV/sDX2KfCBMc0MMa64vraSzFfYzv0
 RZb96NYaiOw+XVkwllK6NPt2QH+4Jzf8hjT02njTzTLt6QPwtM
 djISqz+W5ZHy0H5V2ZOZskJABxcBa9U6SYJZo7YoDWO36Zg3mX
 aVNL0e54BXWH4sk1VkKerPpcMrmkj9/4ccSP8VTc2GJ9hN/XiR
 aO5s1QfXtG/oEHBRmaV4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 March 2013, Mark Brown wrote:
> On Thu, Mar 28, 2013 at 12:39:46PM +0000, Arnd Bergmann wrote:
> 
> > Axel Lin reported the same problem and I fixed the below code earlier
> > today by using the correct __attribute__((unused)) and dropping the
> > section magic for the non-OF case. My patch now looks contains the
> 
> That still looks like it'll reference the function?

Yes, that is intentional. The idea is to create a reference to the
function so gcc doesn't complain about unused symbols if the function
gets marked static, but at the same time mark the data structure we
define as unused so gcc can drop the structure as well as the function
if they are not referenced from anywhere else.  This should let us
get away with fewer #ifdef hacks in the code, better build-time coverage
but without producing larger object code.

> > change below. I also proposed a fix for the clocksource driver
> > at http://lkml.org/lkml/2013/3/26/103.
> 
> This is a different driver that I'm trying to look at here, the s3c24xx
> one which is still not merged.  

Ah, sorry about that. It seems to have the same bug.

	Arnd
