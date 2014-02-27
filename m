Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaB0LdD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:33:03 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:61574 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaB0LdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:33:00 -0500
MIME-Version: 1.0
In-Reply-To: <CAPXgP11+GUhMk+JPzCMZ4w_CQrbFTwqQm0g7HMfsrppACGcOTg@mail.gmail.com>
References: <1393253450-12217-1-git-send-email-hare@suse.de>
	<CANq1E4Tt4bomRh9i1CL6LDYFi4afX1pPABJSczRSGsMJZsiqqg@mail.gmail.com>
	<530C4B65.2060207@suse.de>
	<CANq1E4RypUFd5vHbLnqM8tdFr3P7gLR=HTtYhf=Bf4nWtPbCiQ@mail.gmail.com>
	<CAPXgP11+GUhMk+JPzCMZ4w_CQrbFTwqQm0g7HMfsrppACGcOTg@mail.gmail.com>
Date: Thu, 27 Feb 2014 12:33:00 +0100
Message-ID: <CANq1E4THSkTHMn95v9dSzPmk_+o4DSqWv3R11tO6gTsjHR7yjw@mail.gmail.com>
Subject: Re: [PATCHv3] tty: Set correct tty name in 'active' sysfs attribute
From: David Herrmann <dh.herrmann@gmail.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Hannes Reinecke <hare@suse.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ray Strode <halfline@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Werner Fink <werner@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Feb 27, 2014 at 12:16 PM, Kay Sievers <kay@vrfy.org> wrote:
> On Tue, Feb 25, 2014 at 10:38 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
>> On Tue, Feb 25, 2014 at 8:51 AM, Hannes Reinecke <hare@suse.de> wrote:
>
>>> Positive?
>>> I thought this was precisely the problem, ->device() changing the
>>> index '0' into something non-zero.
>>> The reports we had were that the line 'tty0' changed into 'tty1'.
>>> Hence ->device() converted cs[i]->index (which is '0') into index
>>> (which is '1').
>>> Hence the check would be correct, wouldn't it?
>>
>> If "cs[i]" points to tty0, then cs[i]->index is 0. If you call
>> ->device(), it will store 1 (or !=0) in "index". Thus, "(driver &&
>> (index > 0))" will be true and you will write tty1 into the file
>> instead of tty0. So you don't want to check whether the new value is
>> non-zero, but whether the *previous* value was 0, turning this into:
>>
>> if (driver && (cs[i]->index > 0 || driver->major != TTY_MAJOR))
>>
>> So loosely speaking, we use the new code only for devices which either
>> are not a VT or have an idx > 0. Otherwise, we use our fallback.
>
> Hannes, David, care to update the patch to do that? It all sounds fine
> to me. And we should get this merged again.

I have picked it up and resent a fixed patch. I screwed up the version
field, so it's called v3 again.. sorry.

Thanks
David
