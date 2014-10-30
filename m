Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbaJ3IU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 04:20:29 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:51225 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaJ3IUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 04:20:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, tj@kernel.org, marcel@holtmann.org,
        desrt@desrt.ca, hadess@hadess.net, dh.herrmann@gmail.com,
        tixxdz@opendz.org, simon.mcvittie@collabora.co.uk, daniel@zonque.org,
        alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk,
        teg@jklm.no
Subject: Re: kdbus: add header file
Date: Thu, 30 Oct 2014 09:20:20 +0100
Message-ID: <3546486.lOZcZMmXYe@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414620056-6675-3-git-send-email-gregkh@linuxfoundation.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <1414620056-6675-3-git-send-email-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:2ufJYzAdVA1DE/G9c4MxMWcXv1BpVleNhb5IEuQOCmY
 D3VOdCENBnSArhNQDnU/SmbeKqUqF5QUkWti+7WTS1Lahi5T3D
 upEC66fiqOu3Qn1iAvQISGtWLcZGSInu+hFwKPiQiFM6H0sCbx
 A8UxFeUoolWvmlGZAAcKp3qg7tmXVdZPpfVzBLtcHw5H1BwdpB
 kTr/AD15gfoGi/gGRwWLztQbJb53sPR8dAqOuNZyyFskxhR0bW
 vEVVxMc5RE/HUf7BSNxsgVfwltrf+xvxJ+lOu19mg0xy9+9/JM
 jbq03+dKpzcpviy4S0Pv7g/jyuhRsBPXGsfdyw37/ISyh5q3zZ
 kJs1k4w/OkNSYts7+x4k=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 October 2014 15:00:46 Greg Kroah-Hartman wrote:
> +enum kdbus_ioctl_type {
> +       KDBUS_CMD_BUS_MAKE =            _IOW(KDBUS_IOCTL_MAGIC, 0x00,
> +                                            struct kdbus_cmd_make),
> +       KDBUS_CMD_DOMAIN_MAKE =         _IOW(KDBUS_IOCTL_MAGIC, 0x10,
> +                                            struct kdbus_cmd_make),
> +       KDBUS_CMD_ENDPOINT_MAKE =       _IOW(KDBUS_IOCTL_MAGIC, 0x20,
> +                                            struct kdbus_cmd_make),
> +
> +       KDBUS_CMD_HELLO =               _IOWR(KDBUS_IOCTL_MAGIC, 0x30,
> +                                             struct kdbus_cmd_hello),
> +       KDBUS_CMD_BYEBYE =              _IO(KDBUS_IOCTL_MAGIC, 0x31),
> +
> +       KDBUS_CMD_MSG_SEND =            _IOWR(KDBUS_IOCTL_MAGIC, 0x40,
> +                                             struct kdbus_msg),
> +       KDBUS_CMD_MSG_RECV =            _IOWR(KDBUS_IOCTL_MAGIC, 0x41,
> +                                             struct kdbus_cmd_recv),
> +       KDBUS_CMD_MSG_CANCEL =          _IOW(KDBUS_IOCTL_MAGIC, 0x42,
> +                                            struct kdbus_cmd_cancel),
> +       KDBUS_CMD_FREE =                _IOW(KDBUS_IOCTL_MAGIC, 0x43,
> +                                            struct kdbus_cmd_free),
> 

I think in general, using enum is great, but for ioctl command numbers,
we probably want to have defines so the user space implementation can
use #ifdef to see if the kernel version that it is being built for
knows a particular command.

You could do that using 

#define KDBUS_CMD_BUS_MAKE KDBUS_CMD_BUS_MAKE

while keeping the enum, or do it like everybody else using

#define KDBUS_CMD_BUS_MAKE _IOW(KDBUS_IOCTL_MAGIC, 0x00, struct kdbus_cmd_make)

which might in fact help some tools that try to do automated parsing
of header files to find ioctl commands.

	Arnd
