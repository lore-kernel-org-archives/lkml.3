Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab3CKU5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:57:43 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:45423 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab3CKU5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:57:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130311204530.GE14738@redhat.com>
References: <20130311182655.GB12107@redhat.com>
	<513E2695.3080707@zytor.com>
	<CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com>
	<513E28B8.3000502@zytor.com>
	<CAE9FiQW-gpEMmc6kseb7E+TEg1F9CqEYZBRDiJ3bDY=t6zGRmg@mail.gmail.com>
	<20130311192021.GF12107@redhat.com>
	<513E36CB.5040908@zytor.com>
	<20130311201245.GC14738@redhat.com>
	<513E3C44.9030402@zytor.com>
	<87hakhk6xu.fsf@xmission.com>
	<20130311204530.GE14738@redhat.com>
Date: Mon, 11 Mar 2013 13:57:41 -0700
X-Google-Sender-Auth: BJBq_9XQIbOihkU1OygWETfgaWY
Message-ID: <CAE9FiQUPVP59Ngo2TGABD-vwVRA7rhgE+MgBCT1b=U_EQgsUdQ@mail.gmail.com>
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        WANG Chao <chaowang@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 1:45 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> In my experience, trying to keep foot-print small has kind of been a
> losing battle.
>
> - People want more functionality in second kernel, want to dump to more
>   complicated IO stacks and that requires pulling in more drivers,
>   more libraries, more daemons, more user space tools and what not.
>
> - Now we use dracut generated initramfs and it has been growing in size.
>   Now systemd has been pulled in too.
>
> - Drivers keep on increasing their memory usage.

If the dump file will be only put one place, why should all the drivers
for all devices get loaded?
for example: dump will be on disk with one scsi controller, can you only
load driver that contoller? and forget about all other storage controller and
network etc drivers.

Thanks

Yinghai
