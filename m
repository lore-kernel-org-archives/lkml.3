Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbaK3VIN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 16:08:13 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbaK3VIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 16:08:12 -0500
Message-ID: <547B8731.90305@nod.at>
Date: Sun, 30 Nov 2014 22:08:01 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        gregkh@linuxfoundation.org, rafael.j.wysocki@intel.com,
        pebolle@tiscali.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: defconfig: Enable CONFIG_FHANDLE
References: <1416958612-7448-1-git-send-email-richard@nod.at> <20141130205430.GD16151@dastard>
In-Reply-To: <20141130205430.GD16151@dastard>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 30.11.2014 um 21:54 schrieb Dave Chinner:
> On Wed, Nov 26, 2014 at 12:36:52AM +0100, Richard Weinberger wrote:
>> systemd has a hard dependency on CONFIG_FHANDLE.
>> If you run systemd with CONFIG_FHANDLE=n it will somehow
>> boot but fail to spawn a getty or other basic services.
>> As systemd is now used by most x86 distributions it
>> makes sense to enabled this by default and save kernel
>> hackers a lot of value debugging time.
> 
> The bigger question to me is this: why does systemd need to
> store/open by handle rather than just opening paths directly when
> needed? This interface is intended for stable, pathless access to
> inodes across unmount/mount contexts (e.g. userspace NFS servers,
> filesystem backup programs, etc) so I'm curious as to the problem
> systemd is solving using this interface. I just can't see the
> problem being solved here, and why path based security checks on
> every open() aren't necessary...

Digging inter systemd source shows that they are using name_to_handle_at()
to get the mount id of a given path.
The actual struct file_handle result is always ignored.

Thanks,
//richard
