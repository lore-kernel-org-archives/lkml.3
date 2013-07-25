Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab3GYPPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:15:35 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:38010 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab3GYPPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:15:33 -0400
MIME-Version: 1.0
In-Reply-To: <51F13E51.7040808@sr71.net>
References: <1374261785-1615-1-git-send-email-kys@microsoft.com>
 <20130722123716.GB24400@dhcp22.suse.cz> <e06fced3ca42408b980f8aa68f4a29f3@SN2PR03MB061.namprd03.prod.outlook.com>
 <51EEA11D.4030007@intel.com> <3318be0a96cb4d05838d76dc9d088cc0@SN2PR03MB061.namprd03.prod.outlook.com>
 <51EEA89F.9070309@intel.com> <9f351a549e76483d9148f87535567ea0@SN2PR03MB061.namprd03.prod.outlook.com>
 <51F00415.8070104@sr71.net> <d1f80c05986b439cbeef12bcd595b264@BLUPR03MB050.namprd03.prod.outlook.com>
 <51F040E8.1030507@intel.com> <20130725075705.GD12818@dhcp22.suse.cz>
 <4f440c8d96f34711a3f06fb18702a297@SN2PR03MB061.namprd03.prod.outlook.com> <51F13E51.7040808@sr71.net>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 25 Jul 2013 17:15:11 +0200
Message-ID: <CAPXgP10BqFoYLOS+e=aTMqM6mAZrtuWHsrsSJ4+44m+LuzRwiQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] Drivers: base: memory: Export symbols for onlining
 memory blocks
To: Dave Hansen <dave@sr71.net>
Cc: KY Srinivasan <kys@microsoft.com>, Michal Hocko <mhocko@suse.cz>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kamezawa.hiroyuki@gmail.com" <kamezawa.hiroyuki@gmail.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "yinghan@google.com" <yinghan@google.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 5:03 PM, Dave Hansen <dave@sr71.net> wrote:
> On 07/25/2013 04:14 AM, KY Srinivasan wrote:
>> As promised, I have sent out the patches for (a) an implementation of an in-kernel API
>> for onlining  and a consumer for this API. While I don't know the exact reason why the
>> user mode code is delayed (under some low memory conditions), what is the harm in having
>> a mechanism to online memory that has been hot added without involving user space code.
>
> KY, your potential problem, not being able to online more memory because
> of a shortage of memory, is a serious one.
>
> However, this potential issue exists in long-standing code, and
> potentially affects all users of memory hotplug.  The problem has not
> been described in sufficient detail for the rest of the developers to
> tell if you are facing a new problem, or whether *any* proposed solution
> will help the problem you face.
>
> Your propsed solution changes the semantics of existing user/kernel
> interfaces, duplicates existing functionality, and adds code complexity
> to the kernel.

Complexity, well, it's just a bit of code which belongs in the kernel.
The mentioned unconditional hotplug loop through userspace is
absolutely pointless. Such defaults never belong in userspace tools if
they do not involve data that is only available in userspace and
something would make a decision about that. Saying "hello" to
userspace and usrspace has a hardcoded "yes" in return makes no sense
at all. The kernel can just go ahead and do its job, like it does for
all other devices it finds too.

Kay
