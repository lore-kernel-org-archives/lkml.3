Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984Ab3ANTuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 14:50:25 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:48420 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757415Ab3ANTuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 14:50:22 -0500
MIME-Version: 1.0
In-Reply-To: <50F455A3.4070706@zytor.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-23-git-send-email-yinghai@kernel.org>
	<20130113214132.GB17200@liondog.tnic>
	<CAE9FiQVQRAOtw7kiPJO3xszJx9uPFjgK82PjbvTyqzJgujdicw@mail.gmail.com>
	<50F4452D.2060000@zytor.com>
	<CAE9FiQXkgoLKp3ZnOcM9gLDJNGNxUE8WSRXiQy1G_v5Os5_v2A@mail.gmail.com>
	<50F455A3.4070706@zytor.com>
Date: Mon, 14 Jan 2013 11:50:20 -0800
X-Google-Sender-Auth: 85-3C59i3thfOb3-ixzGgdboeeQ
Message-ID: <CAE9FiQUtbpo0njyPjPED=esKKnSdFs9ry4pFjG1y0LvHxkqV4w@mail.gmail.com>
Subject: Re: [PATCH v7u1 22/31] x86, boot: add fields to support load bzImage
 and ramdisk above 4G
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 10:59 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> No, there were other fields that were also left uninitialized, per your
> analysis from last year.  I don't remember the details, but I seem to
> recall they included the EFI and graphics-related fields.
>
> So yes, just zero them all out.

?

+static void sanitize_real_mode(struct boot_params *real_mode)
+{
+       if (real_mode->sentinel) {
+               /*fields in boot_params are not valid, clear them */
+               memset(&real_mode->olpc_ofw_header, 0,
+                      (char *)&real_mode->alt_mem_k -
+                       (char *)&real_mode->olpc_ofw_header);
+               memset(&real_mode->_pad7[0], 0,
+                      (char *)&real_mode->edd_mbr_sig_buffer[0] -
+                       (char *)&real_mode->_pad7[0]);
+               memset(&real_mode->_pad8[0], 0,
+                      (char *)&real_mode->eddbuf[0] -
+                       (char *)&real_mode->_pad8[0]);
+               memset(&real_mode->_pad9[0], 0, sizeof(real_mode->_pad9));
+       }
+}
+
