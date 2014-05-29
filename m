Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964988AbaE2NyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:54:01 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:62301 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932945AbaE2Nx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:53:59 -0400
MIME-Version: 1.0
In-Reply-To: <CANqRtoTzOn5d9qB85sXvmLYhoTDMDtbjSkLbz9V4FRmzFM3ycQ@mail.gmail.com>
References: <20140529131650.2329.3197.sendpatchset@w520>
	<20140529131732.2329.50630.sendpatchset@w520>
	<20140529132034.GB15585@mwanda>
	<CANqRtoTzOn5d9qB85sXvmLYhoTDMDtbjSkLbz9V4FRmzFM3ycQ@mail.gmail.com>
Date: Thu, 29 May 2014 22:53:57 +0900
Message-ID: <CANqRtoQDQLsWOyRSbQmtbmJc_qO=5X3ZMK12ZuwZ-FSR1iWCog@mail.gmail.com>
Subject: Re: [PATCH v2 04/05] staging: board: Initial board staging support
From: Magnus Damm <magnus.damm@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        devel <devel@driverdev.osuosl.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 10:27 PM, Magnus Damm <magnus.damm@gmail.com> wrote:
> Hi Dan,
>
> On Thu, May 29, 2014 at 10:20 PM, Dan Carpenter
> <dan.carpenter@oracle.com> wrote:
>> On Thu, May 29, 2014 at 10:17:32PM +0900, Magnus Damm wrote:
>>> --- /dev/null
>>> +++ work/drivers/staging/board/Kconfig        2014-05-29 21:40:41.000000000 +0900
>>> @@ -0,0 +1,7 @@
>>> +config STAGING_BOARD
>>> +     boolean "Staging Board Support"
>>> +     help
>>> +       Select to enable per-board staging support code.
>>> +
>>> +       If in doubt, say N here.
>>> +
>>
>> Actually, you're probably going to need to add a bunch of dependencies
>> here or it will break "make randconfig" right away.  Sorry that I forgot
>> about this in the first review.
>
> Good point, thanks for checking. I will have a look at this and add
> dependencies to make sure it builds on a wide range of platforms.

To begin with, this hunk fixes the i386_defconfig + staging board build.

--- 0011/drivers/staging/board/Kconfig
+++ work/drivers/staging/board/Kconfig    2014-05-29 22:32:39.000000000 +0900
@@ -1,5 +1,6 @@
 config STAGING_BOARD
     boolean "Staging Board Support"
+    depends on OF && OF_ADDRESS
     help
       Select to enable per-board staging support code.

Actually, there are not many dependencies - I believe the OF bits is about it.

Cheers,

/ magnus
