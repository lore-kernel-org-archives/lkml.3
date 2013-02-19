Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877Ab3BSSIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:08:12 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:35247 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758727Ab3BSSIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:08:11 -0500
Date: Tue, 19 Feb 2013 10:08:49 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Chris Li <lkml@chrisli.org>
Cc: linux-kernel@vger.kernel.org, robert.moore@intel.com, feng.tang@intel.com,
        len.brown@intel.com, daniel.vetter@ffwll.ch
Subject: Re: i915 black screen introduced by ACPI changes
Message-ID: <20130219100849.72d2330b@jbarnes-desktop>
In-Reply-To: <CANeU7QmbzX4Tx1Dtu6xOiYzr6h6_8tPQvVG32Wvkt=5wAwEEAg@mail.gmail.com>
References: <CANeU7QmbzX4Tx1Dtu6xOiYzr6h6_8tPQvVG32Wvkt=5wAwEEAg@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2013 20:43:47 -0800
Chris Li <lkml@chrisli.org> wrote:

> My Lenovo Y580 laptop with FC18 start to get black screen after the kernel
> upgrade to 3.7.xxx
> 
> The black screen happens about the time kernel switch to using VT console.
> At the point of black screen, no response of cap locks key led no network
> connection. The machine seems dead.

Can you set up netconsole and see if you can get any output from the
boot, if we're lucky maybe you'll see a panic...

> The CPU is i7 and it has two video card. The Intel build-in video card
> and Gtx 660M Nvidia card.
> 
> This is very annoying. I did some poking around it:
> - It was fine on the FC18 3.6.xxx kernel before the upgrade.
> - The black screen exists with FC18 3.7.xxx kernel
> - The black screen also exists in latest tip of linux-2.6.
> - Switch to multi-user mode booting does not get rid of the black screen.
> - Get rid of the "rhrb quit" does not help either.
> - When the black screen happen, cap lock LED does not response to cap locks.
> - No networking when black screen happen. The only thing to do is
> reboot the system.
> - Adding "i915.modeset=0" will allow the kernel to boot into GUI login. However,
>   logout of X will cause the machine to hang similar to the black screen.
> - Suspend and resume will get stuck at the black screen with"i915.modeset=0".
> - Kernel console and X is using the Intel driver for display.

I don't know about the ACPI change mentioned, but ACPI is involved in
dual-GPU configurations.  Maybe the change affected the default
behavior and pointed more functions at the nVidia device rather than
the Intel?

-- 
Jesse Barnes, Intel Open Source Technology Center
