Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbaEFUgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:36:23 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:45860 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbaEFUgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:36:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140506202951.GA5769@saruman.home>
References: <20140506202951.GA5769@saruman.home>
Date: Tue, 6 May 2014 16:36:20 -0400
X-Google-Sender-Auth: cw-LsSa2QEqnRnkinp2iLi5x_oA
Message-ID: <CAKb7Uviy4cTDYbuvKxkA+Jioq1MU0S2qniiArWWn2hY2e170tQ@mail.gmail.com>
Subject: Re: possible deadlock on nouveau
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: balbi@ti.com
Cc: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Dave Airlie <airlied@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Martin Peres <martin.peres@labri.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2014 at 4:29 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> Just caught this with v3.14-rc4 running with
>
>         01:00.0 VGA compatible controller: NVIDIA Corporation GK107 [GeForce GTX 650] (rev a1)
>
> full dmesg attached
>
> [  239.589213] ======================================================
> [  239.589214] [ INFO: possible circular locking dependency detected ]
> [  239.589216] 3.15.0-rc4-fb+ #5 Not tainted
> [  239.589217] -------------------------------------------------------
> [  239.589218] swapper/1/0 is trying to acquire lock:
> [  239.589219]  (&(&priv->lock)->rlock#2){-.....}, at: [<ffffffff814a6b98>] nouveau_therm_update+0x48/0x310
> [  239.589228]
> [  239.589228] but task is already holding lock:
> [  239.589230]  (&(&priv->sensor.alarm_program_lock)->rlock){-.....}, at: [<ffffffff814a85a4>] alarm_timer_callback+0x54/0xe0
> [  239.589234]
> [  239.589234] which lock already depends on the new lock.

I believe this is fixed by
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=61679fe153b2b9ea5b5e2ab93305419e85e99a9d

Try a more recent kernel? Or did you perhaps mean that you were
running into this with v3.15-rc4, in which case that commit didn't fix
the issue hard enough...

  -ilia
