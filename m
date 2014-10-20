Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbaJTXnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 19:43:50 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46112 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbaJTXnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 19:43:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140905221029.GA35667@core.coreip.homeip.net>
References: <1409899047-13045-1-git-send-email-mcgrof@do-not-panic.com>
 <1409899047-13045-3-git-send-email-mcgrof@do-not-panic.com> <20140905221029.GA35667@core.coreip.homeip.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 21 Oct 2014 01:43:25 +0200
X-Google-Sender-Auth: sTULYTJs5hE2iNfoIVO-o1oJ3aM
Message-ID: <CAB=NE6VV97M=iXRQZpGUhEksrqE4JBVDSAU1Wjx_viqatsirmw@mail.gmail.com>
Subject: Re: [RFC v2 2/6] driver-core: add driver async_probe support
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wu Zhangjin <falcon@meizu.com>, Takashi Iwai <tiwai@suse.de>,
        Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, hare <hare@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Benjamin Poirier <bpoirier@suse.de>,
        Santosh Rastapur <santosh@chelsio.com>, Kay Sievers <kay@vrfy.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tim Gardner <tim.gardner@canonical.com>,
        Pierre Fersing <pierre-fersing@pierref.org>,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        Casey Leedom <leedom@chelsio.com>,
        Hariprasad S <hariprasad@chelsio.com>,
        "mpt-fusionlinux.pdl" <MPT-FusionLinux.pdl@avagotech.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> index 83e910a..49fe573 100644
> --- a/drivers/base/bus.c
> +++ b/drivers/base/bus.c
> @@ -10,6 +10,7 @@
>   *
>   */
>
> +#include <linux/async.h>
>  #include <linux/device.h>
>  #include <linux/module.h>
>  #include <linux/errno.h>
> @@ -547,15 +548,12 @@ void bus_probe_device(struct device *dev)
>  {
>         struct bus_type *bus = dev->bus;
>         struct subsys_interface *sif;
> -       int ret;
>
>         if (!bus)
>                 return;
>
> -       if (bus->p->drivers_autoprobe) {
> -               ret = device_attach(dev);
> -               WARN_ON(ret < 0);
> -       }
> +       if (bus->p->drivers_autoprobe)
> +               device_initial_probe(dev);
>
>         mutex_lock(&bus->p->mutex);
>         list_for_each_entry(sif, &bus->p->interfaces, node)
> @@ -657,6 +655,17 @@ static ssize_t uevent_store(struct device_driver *drv, const char *buf,
>  }
>  static DRIVER_ATTR_WO(uevent);

Based on my review with my latest changes this is what I was missing,
I'll be sure to address this.

 Luis
