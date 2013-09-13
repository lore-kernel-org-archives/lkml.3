Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab3IMLIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 07:08:34 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:54709 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab3IMLIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 07:08:32 -0400
MIME-Version: 1.0
X-Originating-IP: [89.2.206.189]
In-Reply-To: <CAG-2HqWcnZ-z7EbDd0aAj6y_Ho6szfRZUiK0psEnmoz17Kw-xA@mail.gmail.com>
References: <1378302428-19758-1-git-send-email-teg@jklm.no>
 <mj+md-20130904.134928.12262.nikam@ucw.cz> <CAG-2HqWcnZ-z7EbDd0aAj6y_Ho6szfRZUiK0psEnmoz17Kw-xA@mail.gmail.com>
From: Tom Gundersen <teg@jklm.no>
Date: Fri, 13 Sep 2013 13:08:09 +0200
Message-ID: <CAG-2HqVex23K1Omck6rhBsW9dUZTvsORcZF9xFO9jpfhdPO0CQ@mail.gmail.com>
Subject: Re: [PATCH RESEND][pciutils] libpci: pci_id_lookup - add udev/hwdb support
To: Martin Mares <mj@ucw.cz>
Cc: linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 4, 2013 at 4:59 PM, Tom Gundersen <teg@jklm.no> wrote:
> On Wed, Sep 4, 2013 at 3:57 PM, Martin Mares <mj@ucw.cz> wrote:
>> Hello!
>>
>> First of all: Sorry for not replying to the first mail. I do not follow
>> linux-pci too much these days (or, I do that in big batches).
>
> No problem, I guessed as much.
>
>>> This lets you select hwdb support at compile time.
>>>
>>> hwdb is an efficient hardware database shipped with recent versions of udev.
>>> It contains among other sources pci.ids so querying hwdb rather than reading
>>> pci.ids directly should give the same result.
>>>
>>> Ideally Linux distros using udev could stop shipping pci.ids, but use hwdb
>>> as the only source of this information, which this patch allows.
>>
>> Generally, I will be glad to include hwdb support in libpci.
>
> Great.
>
>>> +     if [ -f /usr/include/libudev.h -o -f /usr/local/include/libudev.h ] ; then
>>> +             HWDB=yes
>>> +     else
>>> +             HWDB=no
>>> +     fi
>>
>> Does this make sense? Does every version of libudev support hwdb?
>
> Good point. I'll replace it with a pkg-config call, is that acceptable?
>
>>> @@ -86,8 +91,58 @@ char
>>>  *pci_id_lookup(struct pci_access *a, int flags, int cat, int id1, int id2, int id3, int id4)
>>>  {
>>>    struct id_entry *n, *best;
>>> -  u32 id12 = id_pair(id1, id2);
>>> -  u32 id34 = id_pair(id3, id4);
>>> +  u32 id12, id34;
>>> +
>>> +#ifdef PCI_HAVE_HWDB
>>> +  if (!(flags & PCI_LOOKUP_SKIP_LOCAL))
>>> +    {
>>
>> As you wrote it, hwdb has always priority over pci.ids (unless local lookup is
>> disabled). As a user, I would expect that pci.ids (being a part of the pciutils)
>> is the primary source of data and other sources (network lookups, hwdb) are
>> used only if pci.ids do not match or if explicitly requested.
>
> Hm, this was actually intentional. The reason being that I'd like to
> avoid reading in the pci.ids db in the common case, as using the hwdb
> should be much more efficient (it is most likely already in memory and
> lookup is constant time), and also we (at the distro level) want to
> move away from the {usb,pci}.ids and rather default to hwdb
> everywhere.
>
> My original intention was to make hwdb a replacement for pci.ids, but
> I ended up going the less invasive route, would making it a
> replacement be more acceptable?
>
> If not, I'll just swap around the priority, not a problem.

Hi Martin,

Any comments on the above before I resubmit?

Cheers,

Tom
