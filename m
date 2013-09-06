Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751128Ab3IFX5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 19:57:41 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:52876 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab3IFX5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 19:57:39 -0400
MIME-Version: 1.0
In-Reply-To: <CANq1E4Rf4c4zj1mD1aPr93Q2_M65DCEJhuLqcBWa5uH9tcKuWA@mail.gmail.com>
References: <alpine.LNX.2.00.1309061202050.26934@pobox.suse.cz>
	<20130906202022.GA353@x4>
	<CANq1E4Rf4c4zj1mD1aPr93Q2_M65DCEJhuLqcBWa5uH9tcKuWA@mail.gmail.com>
Date: Fri, 6 Sep 2013 16:57:38 -0700
X-Google-Sender-Auth: e-2bkYspLzUEBLFYwZQAY205dG4
Message-ID: <CA+55aFzg-dv-N7UjXx2pxUJ+QQOOy0qtp_e94PDSM=tVd=LgUw@mail.gmail.com>
Subject: Re: [GIT] HID for 3.12 merge window
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jiri Kosina <jkosina@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 6, 2013 at 2:50 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
> On Fri, Sep 6, 2013 at 10:20 PM, Markus Trippelsdorf
>>
>>  commit 61e00655e9cb82e034eb72b95a51072e718d14a7
>>  Author: David Herrmann <dh.herrmann@gmail.com>
>>  Date:   Mon Aug 26 19:14:46 2013 +0200
>>
>>      Input: introduce BTN/ABS bits for drums and guitars
>>
>> The commit above breaks my Logitech mouse. The mouse cursor just sits in
>> the middle of the screen and doesn't react to movements. dmesg is
>> normal, but Xorg.0.log says:
>
> Ok, the issue is the kernel assumes ABS_MAX to be a power-of-2 minus 1
> (used as mask). That wasn't really obvious to me. Attached is a patch
> which should fix that. Could you apply it on top of linus/master and
> give it a try?

Gah. I just wasted too much time bisecting down my logitech wireless
keyboard not working to within a few commits of this, and decided to
just try your patch.

And yes, it makes my keyboard work.

Dmitry, should I just apply the patch, or should we revert and use
other bits? Please, this needs to be resolved, I stopped merging when
I noticed this problem..

          Linus
