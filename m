Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936372Ab3DIQdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 12:33:11 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:61771 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934149Ab3DIQdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 12:33:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130409154820.GE32476@hansolo.jdub.homelinux.org>
References: <CAGXu5j+ntBM5ZwO9Xqa3sWaEW3nSpR8wsL7poTJ6wZOp5x0Lhw@mail.gmail.com>
	<1361998001.2110.22.camel@localhost>
	<20130227221954.GJ2071@hansolo.jdub.homelinux.org>
	<CAGXu5j+aADfSpBcz9=LVtREQQiW4d3Jd8t7nQKbih7oUhvQghg@mail.gmail.com>
	<20130322145448.f44f9d10a36620c1c11535b7@linux-foundation.org>
	<20130322221444.GJ15821@hansolo.jdub.homelinux.org>
	<CAGXu5jL=Lg6OeWyhKBWHowwMeOpFipMOXmBosYHY53MfVMo8fA@mail.gmail.com>
	<1256775981.281402.1364864751771.JavaMail.root@redhat.com>
	<CAGXu5jLU40Vzx+bNyPSArBt_yYNO9sPJ3yLj7z3Yq=pH22W1Gw@mail.gmail.com>
	<20130409005050.GE18176@hansolo.jdub.homelinux.org>
	<20130409154820.GE32476@hansolo.jdub.homelinux.org>
Date: Tue, 9 Apr 2013 09:33:08 -0700
X-Google-Sender-Auth: tMJGQaL0yOz23EeqrBmSb8St6Fc
Message-ID: <CAGXu5jLs1ghuCwcu7crOG1OHuiaP3hmzYY410br_puc9i82-2g@mail.gmail.com>
Subject: Re: [PATCH v2] kmsg: Honor dmesg_restrict sysctl on /dev/kmsg
From: Kees Cook <keescook@chromium.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christian Kujau <lists@nerdbynature.de>,
        "# 3.4.x" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 8:48 AM, Josh Boyer <jwboyer@redhat.com> wrote:
> The dmesg_restrict sysctl currently covers the syslog method for access
> dmesg, however /dev/kmsg isn't covered by the same protections.  Most
> people haven't noticed because util-linux dmesg(1) defaults to using the
> syslog method for access in older versions.  With util-linux dmesg(1)
> defaults to reading directly from /dev/kmsg.
>
> Fix this by reworking all of the access methods to use the
> check_syslog_permissions function and adding checks to devkmsg_open and
> devkmsg_read.
>
> This fixes https://bugzilla.redhat.com/show_bug.cgi?id=903192
>
> Reported-by: Christian Kujau <lists@nerdbynature.de>
> CC: stable@vger.kernel.org
> Signed-off-by: Eric Paris <eparis@redhat.com>
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>

Thanks!

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Chrome OS Security
