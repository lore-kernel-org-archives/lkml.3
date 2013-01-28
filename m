Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab3A1JII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 04:08:08 -0500
Received: from canardo.mork.no ([148.122.252.1]:46982 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab3A1JIF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 04:08:05 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Michael Leun <lkml20130126@newton.leun.net>
Cc: Freddy Xin <freddy@asix.com.tw>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        louis@asix.com.tw, davem@davemloft.net, Support@asix.com.tw
Subject: Re: [PATCH, resubmit] ax88179_178a: ASIX AX88179_178A USB 3.0/2.0 to gigabit ethernet adapter driver
Organization: m
References: <1358908337-13841-1-git-send-email-freddy@asix.com.tw>
	<20130127001347.584711b2@xenia>
Date: Mon, 28 Jan 2013 10:07:32 +0100
In-Reply-To: <20130127001347.584711b2@xenia> (Michael Leun's message of "Sun,
	27 Jan 2013 00:13:47 +0100")
Message-ID: <87zjztptez.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Michael,

Michael Leun <lkml20130126@newton.leun.net> writes:

> I would vote to not accept that driver for mainline as long as this
> issues are not fixed. 
>
> The vendor should not be able to claim "hooray, hooray, great device,
> we even have an driver in linux main line" when it is actually such an
> useless crap.

Well, that is fortunately not how these things work. The main goal is
getting the devices supported in the kernel. Bugs can be fixed.  If a
vendor can get any positive gain out of having a driver in mainline,
then that is good for everyone, isn't it?  Of course, we can all agree
that the effect of a *working* driver is more positive than a
non-working driver...

For now, the main focus should be fixing the issues which has been noted
during review.  Your testing feedback is of course very useful, but you
probably need to back them up with actual code change proposals if they
are going to be dealt with at this stage.

> Of course I'm offering to help with any information or testing, but
> unfortunately I do not have the knowhow to fix anything myself. 

I believe this is where you are totally wrong.  You obviuously have the
ability to create a few simple test cases for yourself and see if the
driver behaves as you expect.  That is very useful.

And you have a device.  That is also useful.

Now, the driver source code is available.  And there is another Asix
driver in the kernel which already has been cleaned up and can be used
as an example. And maybe even partly used for the new devices as well,
if the code is duplicated?  I have not looked at this in detail, but I
suspect that much of the problem with the ax88179_178a driver is that it
has completely ignored all the work that has gone into the asix driver
after it was mainlined.  I find it unlikely that there is no reusable
code in the asix_devices.c, asix_common.c and ax88172a.c files.  Trying
to rewrite ax88179_178a to share as much code as possible seems like the
best way to clean it up and fix bugs.

You have documents like
http://www.kernel.org/doc/Documentation/SubmittingPatches helping a lot
with cleanup jobs like this, because it is mostly about just following
that recipe.  If you do, then the code will be reviewable by the
community because the size will be reduced and the style readable.  And
the driver might even work, as the cleanup will quite possibly reveal a
number of bugs...

Please consider this option.  Reading and fixing up C code is not very
difficult. Getting this driver into the kernel in a good shape is mostly
just monkey work.  But some monkey has to do it :-)


Bjørn
