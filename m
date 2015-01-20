Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbbATMyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:54:07 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:44008 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbbATMyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:54:05 -0500
Message-ID: <54BE4FE8.7030604@gmail.com>
Date: Tue, 20 Jan 2015 13:54:00 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Daniel Mack <daniel@zonque.org>, Florian Weimer <fw@deneb.enyo.de>,
        David Herrmann <dh.herrmann@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: mtk.manpages@gmail.com, Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tom Gundersen <teg@jklm.no>, Jiri Kosina <jkosina@suse.cz>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux API <linux-api@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Djalal Harouni <tixxdz@opendz.org>
Subject: Re: kdbus: add documentation
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>	<1416546149-24799-2-git-send-email-gregkh@linuxfoundation.org>	<871tolysbb.fsf@mid.deneb.enyo.de>	<CANq1E4RjwCVEVT7031CeiKrNvRFkLBZc4-X1uKdrdzpf=EwJ+A@mail.gmail.com> <87vblwtxee.fsf@mid.deneb.enyo.de> <54BE0D56.5090301@gmail.com> <54BE1116.5060204@zonque.org>
In-Reply-To: <54BE1116.5060204@zonque.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 09:25 AM, Daniel Mack wrote:
> Hi Michael,
> 
> On 01/20/2015 09:09 AM, Michael Kerrisk (man-pages) wrote:
>> On 11/30/2014 06:23 PM, Florian Weimer wrote:
>>> * David Herrmann:
>>>
>>>> On Sun, Nov 30, 2014 at 10:02 AM, Florian Weimer <fw@deneb.enyo.de> wrote:
>>>>> * Greg Kroah-Hartman:
>>>>>
>>>>>> +7.4 Receiving messages
>>>
>>>>> What happens if this is not possible because the file descriptor limit
>>>>> of the processes would be exceeded?  EMFILE, and the message will not
>>>>> be received?
>>>>
>>>> The message is returned without installing the FDs. This is signaled
>>>> by EMFILE, but a valid pool offset.
>>>
>>> Oh.  This is really surprising, so it needs documentation.  But it's
>>> probably better than the alternative (return EMFILE and leave the
>>> message stuck, so that you receive it immediately again—this behavior
>>> makes non-blocking accept rather difficult to use correctly).
>>
>> So, was this point in the end explicitly documented? I not
>> obvious that it is documented in the revised kdbus.txt that
>> Greg K-H sent out 4 days ago.
> 
> No, we've revisited this point and changed the kernel behavior again in
> v3. We're no longer returning -EMFILE in this case, but rather set
> KDBUS_RECV_RETURN_INCOMPLETE_FDS in a new field in the receive ioctl
> struct called 'return_flags'. We believe that's a nicer way of signaling
> specific errors. The message will carry -1 for all FDs that failed to
> get installed, so the user can actually see which one is missing.
> 
> That's also documented in kdbus.txt, but we missed putting it into the
> Changelog - sorry for that.

Thanks for the info, Daniel.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
