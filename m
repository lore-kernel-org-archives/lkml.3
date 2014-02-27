Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbaB0NhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:37:17 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:65029 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbaB0NhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:37:14 -0500
MIME-Version: 1.0
In-Reply-To: <530F3E47.5040904@hurleysoftware.com>
References: <1393425651-7374-1-git-send-email-peter@hurleysoftware.com>
 <CAPXgP112sBy+ErD3xYK8=+0tfXPY80wb8Zco5cJKuKkv7+ZViA@mail.gmail.com> <530F3E47.5040904@hurleysoftware.com>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 27 Feb 2014 14:36:52 +0100
Message-ID: <CAPXgP12ATVb_L2sCaNWN4tozN1Cu0efSWb-VTXdqui4SFkzc=w@mail.gmail.com>
Subject: Re: [PATCH] tty: Add sysfs symlink for console name->tty device
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Ray Strode <halfline@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        Werner Fink <werner@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 2:31 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
> On 02/27/2014 06:13 AM, Kay Sievers wrote:
>>
>> On Wed, Feb 26, 2014 at 3:40 PM, Peter Hurley <peter@hurleysoftware.com>
>> wrote:
>>>
>>> Enable a user-space process to discover the underlying tty device
>>> for a console, if one exists, and when the tty device is later
>>> created or destroyed.
>>>
>>> Add sysfs symlinks for registered consoles to their respective
>>> devices in [sys/class,sys/devices/virtual]/tty/console.
>>> Scan consoles at tty device (un)registration to handle deferred
>>> console<->device (un)binding.
>>
>> What tool is supposed to read that? I can't think of anything
>> interested in this, as soon as we have fixed the "active" console
>> output.

> With all due respect, that "fix" is a ridiculous hack,

No, it is not. It's fine to handle tty0 special, as it is special.

> being done
> for self-serving expedience.

I don't see the problem.

> It already caused one user-space breakage
> which you did not expect.

That is normal way to do things, only people who don't do things don't
break things. And broken things get fixed, and the "active" file is still
fixable, and that is what we should do.

We don't need to invent new things because we did not get things right
with the first try.

> This sysfs interface is superior in every way.

But nothing uses it now, and probably never will, so I don't see the
need for it at this moment.

Kay
