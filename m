Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923Ab3GRQDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:03:11 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:29044 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab3GRQDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:03:09 -0400
Message-ID: <1374163339.24916.65.camel@misato.fc.hp.com>
Subject: Re: [PATCH] mm/hotplug, x86: Disable ARCH_MEMORY_PROBE by default
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Tang Chen <tangchen@cn.fujitsu.com>,
        "vasilis.liaskovitis" <vasilis.liaskovitis@profitbricks.com>
Date: Thu, 18 Jul 2013 10:02:19 -0600
In-Reply-To: <51E74974.9050605@jp.fujitsu.com>
References: <1374097503-25515-1-git-send-email-toshi.kani@hp.com>
	  <CAHGf_=pND-R=qMHg7b=Fi5SqS6ahXJCG865WsOS2eKWa6g3A7A@mail.gmail.com>
	  <1374103783.24916.49.camel@misato.fc.hp.com>
	  <CAHGf_=q-9C4JZgv9Xp1Z3_Ks1a7t_sOArD3e1myj1EdiH5GBHQ@mail.gmail.com>
	 <1374105078.24916.62.camel@misato.fc.hp.com>
	 <51E74974.9050605@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-18 at 10:48 +0900, Yasuaki Ishimatsu wrote:
> (2013/07/18 8:51), Toshi Kani wrote:
> > On Wed, 2013-07-17 at 19:33 -0400, KOSAKI Motohiro wrote:
> >> On Wed, Jul 17, 2013 at 7:29 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> >>> On Wed, 2013-07-17 at 19:22 -0400, KOSAKI Motohiro wrote:
> >>>> On Wed, Jul 17, 2013 at 5:45 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> >>>>> CONFIG_ARCH_MEMORY_PROBE enables /sys/devices/system/memory/probe
> >>>>> interface, which allows a given memory address to be hot-added as
> >>>>> follows. (See Documentation/memory-hotplug.txt for more detail.)
> >>>>>
> >>>>> # echo start_address_of_new_memory > /sys/devices/system/memory/probe
> >>>>>
> >>>>> This probe interface is required on powerpc. On x86, however, ACPI
> >>>>> notifies a memory hotplug event to the kernel, which performs its
> >>>>> hotplug operation as the result. Therefore, users should not be
> >>>>> required to use this interface on x86. This probe interface is also
> >>>>> error-prone that the kernel blindly adds a given memory address
> >>>>> without checking if the memory is present on the system; no probing
> >>>>> is done despite of its name. The kernel crashes when a user requests
> >>>>> to online a memory block that is not present on the system.
> >>>>>
> >>>>> This patch disables CONFIG_ARCH_MEMORY_PROBE by default on x86,
> >>>>> and clarifies it in Documentation/memory-hotplug.txt.
> >>>>
> >>>> Why don't you completely remove it? Who should use this strange interface?
> >>>
> >>> According to the comment below, this probe interface is used on powerpc.
> >>> So, we cannot remove it, but to disable it on x86.
> >>
> >> I meant x86. Why can't we completely remove ARCH_MEMORY_PROBE section
> >> from x86 Kconfig?
> >
> > Oh, I see what you meant.  I do not expect any need for end-users, but I
> > was not sure if someone working on the memory hotplug development might
> > use it for fake hot-add testing.  Yes, if you folks do not see any need,
> > I will remove it from x86 Kconfig.
> 
> I do not think the interface is necessary. So I vote to Kosaki's opinion.

Thanks for the confirmation!
-Toshi


> 
> Thanks,
> Yasuaki Ishimatsu
> 
> >
> > Thanks,
> > -Toshi
> >
> 
> 


