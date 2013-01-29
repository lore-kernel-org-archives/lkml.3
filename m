Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab3A2O4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 09:56:50 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:35693 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756480Ab3A2O4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 09:56:49 -0500
Message-ID: <1359471400.4985.5.camel@thor.lan>
Subject: Re: 3.8-rc2: lockdep warning in nouveau driver
From: Peter Hurley <peter@hurleysoftware.com>
To: Ben Skeggs <bskeggs@redhat.com>
Cc: dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arend van Spriel <arend@broadcom.com>
Date: Tue, 29 Jan 2013 09:56:40 -0500
In-Reply-To: <50ED5874.5010209@broadcom.com>
References: <50ED5874.5010209@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-09 at 12:45 +0100, Arend van Spriel wrote:
> Maybe this one is already known, but I did not find a post about it. So
> here it is.
> 
> Regards,
> Arend

[snip]

> [    9.589986] =============================================
> [    9.595365] [ INFO: possible recursive locking detected ]
> [    9.600745] 3.8.0-rc2-wl-testing-lockdep-00002-ga524cf0 #1 Not tainted
> [    9.607248] ---------------------------------------------
> [    9.612626] modprobe/163 is trying to acquire lock:
> [    9.617486]  (&subdev->mutex){+.+.+.}, at: [<f8929c12>]
> nv50_fb_vram_new+0x92/0x230 [nouveau]
> [    9.626052]
> [    9.626052] but task is already holding lock:
> [    9.631865]  (&subdev->mutex){+.+.+.}, at: [<f8936505>]
> nv50_disp_data_ctor+0x55/0xc0 [nouveau]
> [    9.640593]
> [    9.640593] other info that might help us debug this:
> [    9.647096]  Possible unsafe locking scenario:
> [    9.647096]
> [    9.652995]        CPU0
> [    9.655430]        ----
> [    9.657867]   lock(&subdev->mutex);
> [    9.661365]   lock(&subdev->mutex);
> [    9.664863]
> [    9.664863]  *** DEADLOCK ***
> [    9.664863]
> [    9.670762]  May be due to missing lock nesting notation

Same.

[    5.995881] =============================================
[    5.995886] [ INFO: possible recursive locking detected ]
[    5.995892] 3.8.0-next-20130125+ttypatch-xeon+lockdep #20130125+ttypatch Not tainted
[    5.995898] ---------------------------------------------
[    5.995904] modprobe/275 is trying to acquire lock:
[    5.995909]  (&subdev->mutex){+.+.+.}, at: [<ffffffffa00d10b8>] nouveau_instobj_create_+0x48/0x90 [nouveau]
[    5.995955] 
[    5.995955] but task is already holding lock:
[    5.995961]  (&subdev->mutex){+.+.+.}, at: [<ffffffffa00da3b5>] nv50_disp_data_ctor+0x65/0xd0 [nouveau]
[    5.995989] 
[    5.995989] other info that might help us debug this:
[    5.995995]  Possible unsafe locking scenario:
[    5.995995] 
[    5.996001]        CPU0
[    5.996004]        ----
[    5.996005]   lock(&subdev->mutex);
[    5.996005]   lock(&subdev->mutex);
[    5.996005] 
[    5.996005]  *** DEADLOCK ***

Regards,
Peter Hurley



