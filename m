Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab3HEFcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 01:32:45 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:47373 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab3HEFcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 01:32:43 -0400
MIME-Version: 1.0
In-Reply-To: <CANLzEksSsMY2pTYTfGzgntF-i_Kus+WeVPyNzW0U7APcGOv_5g@mail.gmail.com>
References: <1374163091-4750-1-git-send-email-enselic@gmail.com>
	<CANLzEksSsMY2pTYTfGzgntF-i_Kus+WeVPyNzW0U7APcGOv_5g@mail.gmail.com>
Date: Mon, 5 Aug 2013 07:32:43 +0200
Message-ID: <CAC-DJzL0VzDxCpsdwjugavBhcFUr+kv+iN9D-Yz_tasw=DF75Q@mail.gmail.com>
Subject: Re: [PATCH 0/1] Platform: x86: chromeos_laptop - convert to
 i2c_driver to handle i915 race
From: Martin Nordholts <enselic@gmail.com>
To: Benson Leung <bleung@chromium.org>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Olof Johansson <olof@lixom.net>, Yufeng Shen <miletus@chromium.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/5 Benson Leung <bleung@chromium.org>:
> Hi Martin,
>
> Thank you for looking into this problem. Obviously, this is a problem
> Olof and our team has been working on as well.

Hi Benson,

Thank you for spending time reviewing and testing my patch. I
understand your team is busy and am honored you took the time to look
at my code.

> Your driver would result in three failed probes in 2 different drivers
> on my board.

Yes that is one down-side; sometimes the detect() function will be
triggered even though the device is not supported (the return -ENODEV
code paths in my driver). I thought that maybe a simpler driver could
make up for unnecessary detect() calls. However ...

> "Detect" is method #3, but it comes with a
> stern warning : Once again, method 3 should be avoided wherever
> possible. Explicit device instantiation (methods 1 and 2) is much
> preferred for it is safer and faster.

... I must admit I did not see this. I realize that this makes my
patch a dead end. I wish I would have seen that earlier, that would
have saved time for everyone. My apologies.

Regarding the interaction with non-i2c devices in chromeos_laptop, I
was thinking that could perhaps have been solved by putting the i2c
stuff in a separate driver, say chromeos_laptop_i2c, but that point is
irrelevant now that you pointed out that the use of the
detect()-method is discouraged by the documentation.

Thank you again for reviewing the patch and for providing feedback.

BR,
Martin
