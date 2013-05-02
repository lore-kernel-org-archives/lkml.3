Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228Ab3EBAhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 20:37:31 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54340 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757893Ab3EBAh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 20:37:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Jonas Heinrich <onny@project-insanity.org>
Cc: len.brown@intel.com, pavel@ucw.cz, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: Re: [Bisected] 3.7-rc1 can't resume (still present in 3.9)
Date: Thu, 02 May 2013 02:45:43 +0200
Message-ID: <1682771.1PVxk2VyJS@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <5181650E.1060805@zytor.com>
References: <20130218155439.GA902@onny> <20130501185104.GC488@onny> <5181650E.1060805@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 01, 2013 11:55:10 AM H. Peter Anvin wrote:
> On 05/01/2013 11:51 AM, Jonas Heinrich wrote:
> > Well, you could give me instructions on how to debug this (I'll do 
> > everything ;)) or I could ship you the Thinkpad T43. I guess this
> > would worth the effort since this bug is somehow critical.
> > 
> > Best regards, Jonas
> 
> I'll put together a debug patch unless I can trick Rafael into doing
> it first...

I'm afraid that code has changed quite a bit since I looked at it last time.
[Jarkko Sakkinen seems to have worked on it lately, CCed.]

Jonas, I wonder what happens if you drop the first hunk of the patch (it just
uses a different register, which shouldn't matter)?  Does it still help then?

If so, there are still a few things you can do to it, e.g:
(1) drop the

-       btl     $WAKEUP_BEHAVIOR_RESTORE_CR4, %edi
-       jnc     1f

lines,
(2) drop the

-       btl     $WAKEUP_BEHAVIOR_RESTORE_EFER, %edi
-       jnc     1f

lines,
(3) drop the

+       jecxz   1f

line,
(4) drop the

+       movl    %eax, %ecx
+       orl     %edx, %ecx
+       jz      1f

lines and see what the minimal patch needed for things to work again is.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
