Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750820Ab3HSNqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 09:46:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab3HSNqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 09:46:32 -0400
Date: Mon, 19 Aug 2013 15:46:26 +0200
From: Petr Tesarik <ptesarik@suse.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Mitchell, Lisa (MCLinux in Fort Collins)" <lisa.mitchell@hp.com>,
        Vivek Goyal <vgoyal@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        bhelgaas@google.com, Jingbai Ma <jingbai.ma@hp.com>
Subject: Re: [Help Test] kdump, x86, acpi: Reproduce CPU0 SMI corruption
 issue after unsetting BSP flag
Message-ID: <20130819154626.39403f5b@hananiah.suse.cz>
In-Reply-To: <a2ff8170-41ad-42f6-9015-850dbe14983d@email.android.com>
References: <5200BFB3.2050202@jp.fujitsu.com>
	<520A10A3.5080303@hp.com>
	<520B4A22.2030800@hp.com>
	<87ob90839p.fsf@xmission.com>
	<5211831B.6090704@jp.fujitsu.com>
	<a2ff8170-41ad-42f6-9015-850dbe14983d@email.android.com>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Aug 2013 19:59:53 -0700
"Eric W. Biederman" <ebiederm@xmission.com> wrote:

> 
> 
> 
> >
> >Sorry Eric, I'm not clear to what you mean by ``short one core''...
> >Which are you suggesting? Disabling BSP if crash happens on AP is
> >reasonable?
> >Or restricting cpus to a single one only just as the current kdump
> >configuration is reasonable?
> 
> I am suggesting we start every cpu except the BSP from the AP we started on.
> 
> N-1 cpus seems like a good tradeoff between performance and reliability for those who need it.

FWIW a large customers of ours is fine with such a limitation. And I
have already tested this approach manually (starting the kdump kernel
with maxcpus=1 and hot-plugging the remaining APs from user-space).

Now that this approach is in line with upstream efforts, I'm going to
test it on some more machines and see if there are any troubles.

@Hatayama-san:
> BTW, I have question that does normal kdump work well if crash happens
> on some AP? I wonder the same issue could happen on the 2nd kernel.

I'm not sure what you mean. Normal kdump starts with "maxcpus=1", and
yes, that works even if the secondary kernel is booted from an AP. OTOH
I suspect that not having any BSP in the system may be the cause of some
mysterious random reboots and/or hangs experienced by some customers.

I'll try setting the BSP flag on the boot CPU unconditionally and see
if it makes any difference.

Petr Tesarik
