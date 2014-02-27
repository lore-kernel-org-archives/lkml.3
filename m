Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbaB0LRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:17:00 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:46870 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaB0LQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:16:59 -0500
MIME-Version: 1.0
In-Reply-To: <CANq1E4RypUFd5vHbLnqM8tdFr3P7gLR=HTtYhf=Bf4nWtPbCiQ@mail.gmail.com>
References: <1393253450-12217-1-git-send-email-hare@suse.de>
 <CANq1E4Tt4bomRh9i1CL6LDYFi4afX1pPABJSczRSGsMJZsiqqg@mail.gmail.com>
 <530C4B65.2060207@suse.de> <CANq1E4RypUFd5vHbLnqM8tdFr3P7gLR=HTtYhf=Bf4nWtPbCiQ@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 27 Feb 2014 12:16:37 +0100
Message-ID: <CAPXgP11+GUhMk+JPzCMZ4w_CQrbFTwqQm0g7HMfsrppACGcOTg@mail.gmail.com>
Subject: Re: [PATCHv3] tty: Set correct tty name in 'active' sysfs attribute
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Hannes Reinecke <hare@suse.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ray Strode <halfline@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Werner Fink <werner@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 10:38 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
> On Tue, Feb 25, 2014 at 8:51 AM, Hannes Reinecke <hare@suse.de> wrote:

>> Positive?
>> I thought this was precisely the problem, ->device() changing the
>> index '0' into something non-zero.
>> The reports we had were that the line 'tty0' changed into 'tty1'.
>> Hence ->device() converted cs[i]->index (which is '0') into index
>> (which is '1').
>> Hence the check would be correct, wouldn't it?
>
> If "cs[i]" points to tty0, then cs[i]->index is 0. If you call
> ->device(), it will store 1 (or !=0) in "index". Thus, "(driver &&
> (index > 0))" will be true and you will write tty1 into the file
> instead of tty0. So you don't want to check whether the new value is
> non-zero, but whether the *previous* value was 0, turning this into:
>
> if (driver && (cs[i]->index > 0 || driver->major != TTY_MAJOR))
>
> So loosely speaking, we use the new code only for devices which either
> are not a VT or have an idx > 0. Otherwise, we use our fallback.

Hannes, David, care to update the patch to do that? It all sounds fine
to me. And we should get this merged again.

Kay
