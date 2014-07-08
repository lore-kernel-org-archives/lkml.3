Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbaGHOdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:33:00 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:43092 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbaGHOc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:32:58 -0400
MIME-Version: 1.0
In-Reply-To: <1404828488-7649-1-git-send-email-andrey.krieger.utkin@gmail.com>
References: <1404828488-7649-1-git-send-email-andrey.krieger.utkin@gmail.com>
Date: Tue, 8 Jul 2014 16:32:57 +0200
X-Google-Sender-Auth: q0KrNqOKy5FMvGVNb5-WlgVwHxU
Message-ID: <CAAsK9AFfn45wyQFsOiCAZXZjXfyPLhz3FxyBO5P_q_48s9ce_g@mail.gmail.com>
Subject: Re: [PATCH] [media] davinci-vpfe: Fix retcode check
From: Levente Kurusa <lkurusa@redhat.com>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>,
        Linux Media <linux-media@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        prabhakar.csengg@gmail.com, Josh Triplett <josh@joshtriplett.org>,
        Archana Kumari <archanakumari959@gmail.com>,
        Lisa Nguyen <lisa@xenapiadmin.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-08 16:08 GMT+02:00 Andrey Utkin <andrey.krieger.utkin@gmail.com>:
> Use signed type to check correctly for negative error code. The issue
> was reported with static analyser:
>
> [linux-3.13/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c:270]:
> (style) A pointer can not be negative so it is either pointless or an
> error to check if it is.
>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=69071
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>

Hmm, while it is true that get_ipipe_mode returns an int, but
the consequent call to regw_ip takes an u32 as its second
argument. Did it cause a build warning for you? (Can't really
check since I don't have ARM cross compilers close-by)
If not, then:

Reviewed-by: Levente Kurusa <lkurusa@redhat.com>

Thanks,
Levente Kurusa
