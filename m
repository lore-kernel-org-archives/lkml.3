Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab3KHBe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 20:34:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab3KHBeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 20:34:25 -0500
Date: Fri, 8 Nov 2013 09:33:30 +0800
From: Dave Young <dyoung@redhat.com>
To: Baoquan He <bhe@redhat.com>
Cc: linux-kernel@vger.kernel.org, mwhitehe@redhat.com, x86@kernel.org,
        chaowang@redhat.com, kexec@lists.infradead.org,
        davej@fedoraproject.org, mingo@redhat.com, holt@sgi.com, hpa@zytor.com,
        rmk+kernel@arm.linux.org.uk, tglx@linutronix.de,
        akpm@linux-foundation.org, vgoyal@redhat.com, trenn@suse.de,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86: make reboot task only run on the appropriate
 processor
Message-ID: <20131108013330.GA4684@dhcp-16-126.nay.redhat.com>
References: <1383642967-12595-1-git-send-email-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383642967-12595-1-git-send-email-bhe@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/13 at 05:16pm, Baoquan He wrote:
> Currently system always reboot after below message when execute "kexec -e".
> 
> [    0.572119] smpboot: Booting Node   0, Processors  #   1 OK
> 
> In commit 1b3a5d02ee070c8f9943333b9b6370f486601e0f, reboot= handling was
> moved to kerne/reboot.c. However, the code to migrate current thread to
> reboot cpu was removed. That cause this incorrect kexec behavior.
> 
> Now add that code block back.

quote a mail from Thomas Renninger <trenn@suse.de>:
Answer his questions here.

> > For the smp boot issue I think there's nothing to do with dracut.
> >
> > Can you try below patch?
> > https://lkml.org/lkml/2013/11/5/88
>
> That seem to have helped, thanks!
>
> Feel free to add:
>
> Tested-by: trenn@suse.de
>
> The problem existed in 3.11 already?
> I had the problem with a 3.11 kernel and tried a
> 3.12 kernel with this patch now.

It's a regression between 3.10 ~ 3.11

>
> It would be great if:
> Cc: stable@vger.kernel.org
> is added as well then.
>

I also like it to be in stable.

Thanks
Dave
