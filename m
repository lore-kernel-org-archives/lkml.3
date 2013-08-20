Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab3HTUIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 16:08:34 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:36724 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab3HTUI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 16:08:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130820200035.GA2524@roeck-us.net>
References: <20130820155735.GA2805@kroah.com>
	<CA+55aFxrPP8=xPWuRVy0HPyiFkT8Mc03zWGKosg+WrEQfqNDfQ@mail.gmail.com>
	<20130820164343.GA3958@kroah.com>
	<20130820200035.GA2524@roeck-us.net>
Date: Tue, 20 Aug 2013 13:08:28 -0700
X-Google-Sender-Auth: x6MPkAiNf2aTY5aYsdJVymX8QDM
Message-ID: <CA+55aFwVmDVfrL+Xhkk+AZf5iZdWunQaMeRGLJ0yKeBh9brTQQ@mail.gmail.com>
Subject: Re: Linux 3.0.92
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg KH <gregkh@linuxfoundation.org>, Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 1:00 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>>
> Does this patch have to be reverted in 3.10 as well ? Linus' e-mail seems to
> suggest it, but Shuah didn't see the problem there.  I ran a quick test with
> 3.10.8 on an x86 system and did not see a problem either, at least not
> immediately.

Do you run with lockdep?

The patch causes a _possibility_ of a deadlock, but unless you have
lockdep enabled, you're almost guaranteed to not actually ever see
that deadlock in practice.

               Linus
