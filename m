Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448Ab3DXVlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 17:41:50 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:62298 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758416Ab3DXVls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 17:41:48 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxVwcf82qUUferCcm-L1u1GgtJ5g21hj3Em1AETyBDTVg@mail.gmail.com>
References: <CAGXu5j+aADfSpBcz9=LVtREQQiW4d3Jd8t7nQKbih7oUhvQghg@mail.gmail.com>
	<20130322145448.f44f9d10a36620c1c11535b7@linux-foundation.org>
	<20130322221444.GJ15821@hansolo.jdub.homelinux.org>
	<CAGXu5jL=Lg6OeWyhKBWHowwMeOpFipMOXmBosYHY53MfVMo8fA@mail.gmail.com>
	<1256775981.281402.1364864751771.JavaMail.root@redhat.com>
	<CAGXu5jLU40Vzx+bNyPSArBt_yYNO9sPJ3yLj7z3Yq=pH22W1Gw@mail.gmail.com>
	<20130409005050.GE18176@hansolo.jdub.homelinux.org>
	<20130409154820.GE32476@hansolo.jdub.homelinux.org>
	<CAGXu5jLs1ghuCwcu7crOG1OHuiaP3hmzYY410br_puc9i82-2g@mail.gmail.com>
	<CAPXgP10Vd3Ucxn77WX7wzQoaUmy-JdOBWvYv4zpGSu9qcd=GoQ@mail.gmail.com>
	<20130424175835.GF15272@hansolo.jdub.homelinux.org>
	<CAGXu5jLaQ=Amui3i5+MyG_3HOVnK-1ZoaLqw=jFDwaQCzE+4qw@mail.gmail.com>
	<CA+55aFxVwcf82qUUferCcm-L1u1GgtJ5g21hj3Em1AETyBDTVg@mail.gmail.com>
Date: Wed, 24 Apr 2013 14:41:47 -0700
X-Google-Sender-Auth: 0pJ3nds0pjhLxi2RUS8itNRxx48
Message-ID: <CAGXu5jKsp6oDf=wAaPOySpDiUAeXShe4L5_LbjROHe9djp8C4Q@mail.gmail.com>
Subject: Re: [PATCH v2] kmsg: Honor dmesg_restrict sysctl on /dev/kmsg
From: Kees Cook <keescook@chromium.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Boyer <jwboyer@redhat.com>, Kay Sievers <kay@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>,
        Christian Kujau <lists@nerdbynature.de>,
        "# 3.4.x" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 2:30 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Apr 24, 2013 at 1:35 PM, Kees Cook <keescook@chromium.org> wrote:
>>
>> That said, I much prefer doing the privilege test at read time since
>> that means passing a file descriptor to another process doesn't mean
>> the new process can just continue reading.
>
> Bullshit.
>
> That's exactly the wrong kind of thinking. If you had privileges to
> open something, and you pass it off, it's *your* choice.

Yes, this is what I was pointing out originally. The semantics of
/proc/kmsg do exactly that: check at open time, which is much cleaner.

Solving the permissions checking delta between the syslog via syscall
and syslog via /proc/kmsg was the original intent of the code so that
capabilities could be dropped after open. And when /dev/kmsg came
along, it didn't follow either convention. I just want to see the
behavior standardized.

-Kees

--
Kees Cook
Chrome OS Security
