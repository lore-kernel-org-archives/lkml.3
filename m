Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbaEFNcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:32:25 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:57137 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223AbaEFNcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:32:22 -0400
MIME-Version: 1.0
In-Reply-To: <s5hha53ujeq.wl%tiwai@suse.de>
References: <s5htx94fkfi.wl%tiwai@suse.de>
	<CAKMK7uHcYvuViEeyxLc75+kMVPPaKMr8svJQysk124--cjGL+g@mail.gmail.com>
	<s5hd2fsffhk.wl%tiwai@suse.de>
	<CAKMK7uGD5JCQSfk+Vuf=qrjU9x+Y+-W3o-xyGyTM_BreR_XZcw@mail.gmail.com>
	<s5hha53ujeq.wl%tiwai@suse.de>
Date: Tue, 6 May 2014 15:32:21 +0200
Message-ID: <CANq1E4QkzqhrgeJrAZ=wxQR751BdSK13E4QjWPWkiq5B8vFr9Q@mail.gmail.com>
Subject: Re: Atomicity in KMS panic notifier
From: David Herrmann <dh.herrmann@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, May 6, 2014 at 3:27 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Mon, 5 May 2014 16:52:45 +0200,
> Daniel Vetter wrote:
>>
>> On Mon, May 5, 2014 at 4:48 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> >
>> > The current problem I see is that the rest of panic notifier chain
>> > won't be called once when we hit the problem in KMS notifier.  So,
>> > this bug in KMS influences on the rest panic behavior.
>> >
>> > Maybe a hackish solution would be to keep KMS notifier at the end of
>> > notifier chain so that it crashes at last.  I don't like this either,
>> > but...
>>
>> You need to do that with both the kms panic notifier in
>> drm_fb_helper.c and with the fbcon panic notifier. And iirc there's
>> also a console->unblank call somewhere which _also_ can end up in
>> ->set_par. But I'm not sure anymore when exactly that one is run, I've
>> tried hard to forget this all ;-)
>
> Looking back at the code again, it seems that fbcon has no panic
> notifier.  It has own notifier chain, but it's a private chain that
> isn't called by the panic.  So, we can forget about fbcon, at least (I
> hope).

fbcon is called through the VT or fbdev layer, which is called by
bust_spinlocks(1) via either unblank_screen() or console_unblank().

Cheers
David
