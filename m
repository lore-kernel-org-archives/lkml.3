Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735AbaJVK0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 06:26:11 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:64394 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbaJVK0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 06:26:09 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 22 Oct 2014 12:23:05 +0200
From: Johan Hovold <johan@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Johan Hovold <johan@kernel.org>, Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Colin Foe-Parker <colin.foeparker@logicpd.com>, nsekhar@ti.com,
        t-kristo@ti.com, j-keerthy@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/12] rtc: omap: fixes and power-off feature
Message-ID: <20141022102305.GM2113@localhost>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <20141015165452.GB15770@saruman>
 <20141015170628.GA13824@localhost>
 <20141015170832.GD15770@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141015170832.GD15770@saruman>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 12:08:32PM -0500, Felipe Balbi wrote:
> On Wed, Oct 15, 2014 at 07:06:28PM +0200, Johan Hovold wrote:
> > On Wed, Oct 15, 2014 at 11:55:02AM -0500, Felipe Balbi wrote:

> > > BTW, how do you test this series ?
> > 
> > Set a 30 second wakealarm using the sysfs attribute of the rtc class
> > device and power off the BBB:
> > 
> > 	echo +30 >wakealarm; poweroff
> 
> sweet!!!! It worked just fine :-)

:)

> Too bad there's yet another DRM bug:
> 
> [  271.150158] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000000
> [  271.150158] 
> [  271.159725] CPU: 0 PID: 1 Comm: systemd-shutdow Not tainted 3.17.0-08392-g7fe2269-dirty #326
> [  271.168567] [<c00175a4>] (unwind_backtrace) from [<c00132f0>] (show_stack+0x20/0x24)
> [  271.176668] [<c00132f0>] (show_stack) from [<c06573a4>] (dump_stack+0x8c/0xa4)
> [  271.184215] [<c06573a4>] (dump_stack) from [<c0654f10>] (panic+0xa0/0x220)
> [  271.191405] [<c0654f10>] (panic) from [<c0049e54>] (do_exit+0x974/0x9d0)
> [  271.198410] [<c0049e54>] (do_exit) from [<c0067694>] (SyS_reboot+0x14c/0x1e8)
> [  271.205870] [<c0067694>] (SyS_reboot) from [<c000f080>] (ret_fast_syscall+0x0/0x48)
> [  271.214023] drm_kms_helper: panic occurred, switching back to text console
> [  271.221312] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000000
> 
> In any case, board still powered up after 30 seconds(-ish). So this gets
> a:
> 
> Tested-by: Felipe Balbi <balbi@ti.com>

Thanks for testing. I didn't include your Tested-by in v2 due to the
invasiveness of the new device-abstraction patch. Still works fine on BBB
here though.

Johan
