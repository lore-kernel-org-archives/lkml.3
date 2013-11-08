Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757Ab3KHQZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 11:25:10 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:57932 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212Ab3KHQZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 11:25:06 -0500
MIME-Version: 1.0
In-Reply-To: <CAMRPzZJwUkQZkhA5E2QW6YVmou2uypytno8Yqb6bzgqhW7kJMA@mail.gmail.com>
References: <bug-60555-41252@https.bugzilla.kernel.org/> <CAErSpo4BKuuo=kz9RLpZNwrM=HnV3Zt7qLeoUCywV6ESoO+=wQ@mail.gmail.com>
 <CAErSpo7nyyfZ8n97hyjkmzfCcPBVFTid0BrVXLwiBA0YhkdREA@mail.gmail.com> <CAMRPzZJwUkQZkhA5E2QW6YVmou2uypytno8Yqb6bzgqhW7kJMA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 8 Nov 2013 09:24:45 -0700
Message-ID: <CAErSpo7+CseUORXRuovB-HUnJeQZCNsdSnsv6JHYuNFKLNNB5w@mail.gmail.com>
Subject: Re: [Bug 60555] New: Some amount of ifconfig cause load average
 increase and system freeze
To: Yaroslav Molochko <onorua@gmail.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 8, 2013 at 5:24 AM, Yaroslav Molochko <onorua@gmail.com> wrote:
> Sorry. I was not using this machine for quite a bit, I've updated to the new
> kernel and updated bug with the information you asked

Thanks.

Note that this appears to be vanilla v3.12, which has e1000e version
2.3.2-k in it.  Intel maintains newer drivers out-of-tree at
http://sourceforge.net/projects/e1000/, and it's possible this is some
bug that has already been fixed.  The current version there looks like
e1000e-2.5.4, released 2013-09-05.

I think only the Intel folks can help you out with this.

Bjorn

>> > On Mon, Jul 15, 2013 at 2:31 AM,  <bugzilla-daemon@bugzilla.kernel.org>
>> > wrote:
>> >> https://bugzilla.kernel.org/show_bug.cgi?id=60555
>> >>
>> >>             Bug ID: 60555
>> >>            Summary: Some amount of ifconfig cause load average increase
>> >>                     and system freeze
>> >>            Product: Drivers
>> >>            Version: 2.5
>> >>     Kernel Version: 3.10.0
>> >>           Hardware: All
>> >>                 OS: Linux
>> >>               Tree: Mainline
>> >>             Status: NEW
>> >>           Severity: normal
>> >>           Priority: P1
>> >>          Component: PCI
>> >>           Assignee: drivers_pci@kernel-bugs.osdl.org
>> >>           Reporter: onorua@gmail.com
>> >>         Regression: No
>> >>
>> >> I've faced with the situation when system stopped to process any
>> >> request.
>> >> Further analysis showed that the load average was around 20, and was
>> >> constantly
>> >> increasing (the normal LA for this system is 0.3-1).
>> >
>> > Thanks for the report; sorry it fell through the cracks.
>> >
>> > Is this problem reproducible?  If so, can you try to reproduce it on
>> > v3.11?  Can you please attach a complete dmesg log and "lspci -vv" (as
>> > root) output to the bugzilla?
>> >
>> > The BUG_ON you're hitting is here, but I don't know what it means:
>> >
>> >     #ifdef CONFIG_GENERIC_HARDIRQS
>> >                 for (i = 0; i < nvec; i++)
>> >                         BUG_ON(irq_has_action(entry->irq + i));
>> >     #endif
>>
>> What's the status of this?  Is it still a problem?  Should we just
>> close the bug as unreproducible?
>>
>> Bjorn
>
>
