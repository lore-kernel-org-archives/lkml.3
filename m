Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab3AKTa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 14:30:57 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:44926 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab3AKTa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 14:30:56 -0500
MIME-Version: 1.0
In-Reply-To: <20130111182547.GA22231@kroah.com>
References: <20130111020046.15463.72333.stgit@starfish.jf.intel.com>
	<20130111182547.GA22231@kroah.com>
Date: Fri, 11 Jan 2013 11:30:54 -0800
X-Google-Sender-Auth: ts0KMkEOCJsz8CzcZtJWE_DTix8
Message-ID: <CAP-MU4MzG_P9fz3_eix=zgzyjijZ5qo1mpKE=r_K7y3xcJqc5Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] ixgbe: request_firmware for configuration parameters
From: Shannon Nelson <shannon.nelson@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: netdev@vger.kernel.org, davem@davemloft.net, dwmw2@infradead.org,
        jeffrey.t.kirsher@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 10:25 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Jan 10, 2013 at 06:02:20PM -0800, Shannon Nelson wrote:
>> Most networking dials and knobs can be set using ethtool, ifconfig, ip link
>> commands, or sysfs entries, all of which can be driven by startup scripts
>> and other configuration tools.  However, they all depend on having a netdev
>> already set up, and we have some low-level device functionality that needs
>> to be sorted out before we start setting up MSI-x and memory allocations.

> Ick, please don't abuse request_firmware() for this type of thing.

Yeah, it seemed ugly to me at first as well, but it grew on me as I
realized that it does solve a problem in a rather elegant way.  While
working this up I discussed this with Mr. Woodhouse thinking that as a
firmware tree maintainer he'd have a similar reaction, but he actually
wasn't opposed to it (David, please speak up if I'm misrepresenting
your comments).

> What's wrong with configfs?  It sounds like it will fit your need, and
> that is what is created for.

configfs has similar problems as sysfs - the driver needs to create
the hooks before it has all the info it might need for some hooks,
there is no persistence across reboots, and I don't think it will help
for initrd images.  Additionally, there would need to be some userland
mechanism to notice that the hooks were there and to feed it the
startup info.  Using a file in the firmware path gives us persistence
and a way for the driver to get info before having to set up
filesystem hooks.  It also gives us a way to get special config info
into the boot image.  And the whole mechanism already exists,
including UDEV hooks that can do more fancy stuff if needed.

sln

-- 
==============================================
Mr. Shannon Nelson         Parents can't afford to be squeamish.
