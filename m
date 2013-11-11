Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab3KKPkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:40:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44142 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314Ab3KKPki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:40:38 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20131111152948.GA11547@redhat.com>
References: <1383642967-12595-1-git-send-email-bhe@redhat.com> <20131108151416.GA13068@redhat.com> <527D0D50.6010607@zytor.com> <20131111152948.GA11547@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x86: make reboot task only run on the appropriate processor
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 11 Nov 2013 07:39:18 -0800
To: Vivek Goyal <vgoyal@redhat.com>
CC: Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        akpm@linux-foundation.org, davej@fedoraproject.org,
        rmk+kernel@arm.linux.org.uk, chaowang@redhat.com, mwhitehe@redhat.com,
        kexec@lists.infradead.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Robin Holt <robinmholt@linux.com>, Robin Holt <robinmholt@gmail.com>
Message-ID: <469ce80c-c6a0-4238-aab5-9a4d8c562387@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, unless there is a better path for it since it is not x86-specific.  I am fine taking it, though.

Vivek Goyal <vgoyal@redhat.com> wrote:
>On Fri, Nov 08, 2013 at 08:12:00AM -0800, H. Peter Anvin wrote:
>> On 11/08/2013 07:14 AM, Vivek Goyal wrote:
>> > 
>> > Hi Bao,
>> > 
>> > This patch fixes the issue for me too. I noticed that we have
>generic
>> > function migrate_to_reboot_cpu() to achieve what we want and rest
>of
>> > the reboot paths are using it. So how about using that function. I 
>> > wrote the new patch below. It works for me. Can you please give it
>> > a try.
>> > 
>> > Thanks
>> > Vivek
>> > 
>> 
>> Is this path exercised for the kdump flow?  migrate_to_reboot_cpu()
>is
>> unsafe in that case.
>
>Hi Peter,
>
>Can you please consider queuing up this patch for next release.
>
>Thanks
>Vivek
>
>> 
>> > Index: linux-2.6/kernel/kexec.c
>> > ===================================================================
>> > --- linux-2.6.orig/kernel/kexec.c	2013-10-16 00:30:50.000000000
>-0400
>> > +++ linux-2.6/kernel/kexec.c	2013-11-08 21:34:02.492072375 -0500
>> > @@ -1676,6 +1676,7 @@ int kernel_kexec(void)
>> >  #endif
>> >  	{
>> >  		kernel_restart_prepare(NULL);
>> > +		migrate_to_reboot_cpu();
>> >  		printk(KERN_EMERG "Starting new kernel\n");
>> >  		machine_shutdown();
>> >  	}
>> > 

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
