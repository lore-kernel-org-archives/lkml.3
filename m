Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab3AUOVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 09:21:38 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:53624 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab3AUOVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 09:21:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH v2 17/76] ARC: Process-creation/scheduling/idle-loop
Date: Mon, 21 Jan 2013 14:21:23 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Frederic Weisbecker" <fweisbec@gmail.com>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <201301181435.15491.arnd@arndb.de> <50FD2432.8010201@synopsys.com>
In-Reply-To: <50FD2432.8010201@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301211421.23794.arnd@arndb.de>
X-Provags-ID: V02:K0:YwQDq+9Z/gfj9srR2KcrqTVjOZWoN3NjlobN1+cOpGq
 utGNBoSgl0u1EKcMuLTfbNjEj1RCmv7hgeeFhHjGxy/JwFdPKA
 JpmIh290nPPGfjskvTg3z3+D5gJv9OmtdcLe3aK3q15ApDFJJA
 sipzkj+rt7HEA76YXr2ijtZKrHj+Fw+6JYbStTtTtOX2Ja7tNB
 f/6JnvCvVGXp0MEEEZwkoo4AG9N+Ta4XfFH6HSGGwpxMI2r2tl
 xsrG6+SGsxWKFxz83LTXivWwcd/pL+uC/Rof/Z+mtqAue/PWuK
 Uc8ug8qgyIVGlh0QpH1nBvi30RDP2vdmCzeE03Q2rsmpb8Imdl
 NTaG0ObPW3W5BLaDKB8o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2013, Vineet Gupta wrote:
> -               while (!need_resched())
> +doze:
> +               local_irq_disable();
> +               if (!need_resched()) {
>                         arch_idle();
> +                       goto doze;
> +               } else {
> +                       local_irq_enable();
> +               }
> 

Ok, that looks like it will work.

	Arnd
