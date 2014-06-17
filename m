Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127AbaFQSUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 14:20:21 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:62394 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932762AbaFQSUT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 14:20:19 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Wei.Yang@windriver.com, stern@rowland.harvard.edu
Cc: wei.yang@windriver.com, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB:gadget: Fix a warning while loading g_mass_storage
In-Reply-To: <1402800030-17078-1-git-send-email-Wei.Yang@windriver.com>
Organization: http://mina86.com/
References: <1401856367-12553-1-git-send-email-Wei.Yang@windriver.com> <1402800030-17078-1-git-send-email-Wei.Yang@windriver.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140617:stern@rowland.harvard.edu::MjYVyiexeYn+tmIY:0000000000000000000000000000000000001411
X-Hashcash: 1:20:140617:wei.yang@windriver.com::nROW1cR1cvhxANJ/:0000000000000000000000000000000000000001Wj5
X-Hashcash: 1:20:140617:linux-usb@vger.kernel.org::pxEzY5KcmXGPLL1C:0000000000000000000000000000000000001eLq
X-Hashcash: 1:20:140617:linux-kernel@vger.kernel.org::P2p+cYVfj23wew+Y:0000000000000000000000000000000003Q+J
X-Hashcash: 1:20:140617:wei.yang@windriver.com::9p3wkT+Vw3iqTYKU:0000000000000000000000000000000000000003nt1
X-Hashcash: 1:20:140617:balbi@ti.com::nQIAGBt9cZosPsa4:000006POs
Date: Tue, 17 Jun 2014 20:20:14 +0200
Message-ID: <xa1ta99bwg81.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15 2014, Wei.Yang@windriver.com wrote:
> From: Yang Wei <Wei.Yang@windriver.com>
>
> While loading g_mass_storage module, the following warning
> is triggered.
>
> WARNING: at drivers/usb/gadget/composite.c:
> usb_composite_setup_continue: Unexpected call
> Modules linked in: fat vfat minix nls_cp437 nls_iso8859_1 g_mass_storage
> [<800179cc>] (unwind_backtrace+0x0/0x104) from [<80619608>] (dump_stack+0x20/0x24)
> [<80619608>] (dump_stack+0x20/0x24) from [<80025100>] (warn_slowpath_common+0x64/0x74)
> [<80025100>] (warn_slowpath_common+0x64/0x74) from [<800251cc>] (warn_slowpath_fmt+0x40/0x48)
> [<800251cc>] (warn_slowpath_fmt+0x40/0x48) from [<7f047774>] (usb_composite_setup_continue+0xb4/0xbc [g_mass_storage])
> [<7f047774>] (usb_composite_setup_continue+0xb4/0xbc [g_mass_storage]) from [<7f047ad4>] (handle_exception+0x358/0x3e4 [g_mass_storage])
> [<7f047ad4>] (handle_exception+0x358/0x3e4 [g_mass_storage]) from [<7f048080>] (fsg_main_thread+0x520/0x157c [g_mass_storage])
> [<7f048080>] (fsg_main_thread+0x520/0x157c [g_mass_storage]) from [<8004bc90>] (kthread+0x98/0x9c)
> [<8004bc90>] (kthread+0x98/0x9c) from [<8000faec>] (kernel_thread_exit+0x0/0x8)
>
> The root cause is that the existing code fails to take into
> account the possibility that common->new_fsg can change while
> do_set_interface() is running, so the value of common->new_fsg
> that gets tested after do_set_interface returns needs to be
> the same as the value used by do_set_interface.
>
> Signed-off-by: Yang Wei <Wei.Yang@windriver.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>  drivers/usb/gadget/f_mass_storage.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> Changes in v3 ----> v4
>
> move "new_fsg = common->new_fsg" out of comm->lock protection, and refine the commit log.
>
> Thanks
> Wei
>
> diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
> index b963939..a7e24c8 100644
> --- a/drivers/usb/gadget/f_mass_storage.c
> +++ b/drivers/usb/gadget/f_mass_storage.c
> @@ -2342,6 +2342,7 @@ static void handle_exception(struct fsg_common *common)
>  	struct fsg_buffhd	*bh;
>  	enum fsg_state		old_state;
>  	struct fsg_lun		*curlun;
> +	struct fsg_dev		*new_fsg;
>  	unsigned int		exception_req_tag;
>  
>  	/*
> @@ -2460,8 +2461,9 @@ static void handle_exception(struct fsg_common *common)
>  		break;
>  
>  	case FSG_STATE_CONFIG_CHANGE:
> -		do_set_interface(common, common->new_fsg);
> -		if (common->new_fsg)
> +		new_fsg = common->new_fsg;
> +		do_set_interface(common, new_fsg);
> +		if (new_fsg)
>  			usb_composite_setup_continue(common->cdev);
>  		break;

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
