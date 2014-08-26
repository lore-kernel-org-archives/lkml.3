Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbaHZW6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 18:58:52 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:47154 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541AbaHZW6u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 18:58:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAPWNY8WG3E7oZdZDdYsrnGM5pG4kWAKkEq0Eh5Hc_uXJ_8zD5g@mail.gmail.com>
References: <1409089544-24221-1-git-send-email-yinghai@kernel.org>
	<53FD01D0.8020203@zytor.com>
	<CAE9FiQUF4THLRfzbnhK61QHpM2zyox4E8LTmyzVF7PnPdpb7jQ@mail.gmail.com>
	<CAPWNY8WG3E7oZdZDdYsrnGM5pG4kWAKkEq0Eh5Hc_uXJ_8zD5g@mail.gmail.com>
Date: Tue, 26 Aug 2014 15:58:50 -0700
X-Google-Sender-Auth: xd6ugv0SVuVPXNfoFGO7dcztBMg
Message-ID: <CAE9FiQVE-UyXQOGTwErxRHJSUP0X61eL+x1L6x90=JToG12btw@mail.gmail.com>
Subject: Re: [PATCH] x86: only load initrd above 4g on second try
From: Yinghai Lu <yinghai@kernel.org>
To: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matt Fleming <matt.fleming@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Anders Darander <anders@chargestorm.se>, linux-efi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 3:16 PM, Mantas Mikulėnas <grawity@gmail.com> wrote:
>
> In particular, I just realized yesterday that I don't know whether
> it's referring to physical or virtual addresses in the initrd load
> code -- and the laptop only has 4 GB of memory, so the kernel
> shouldn't be using larger physical addresses in the first place.
> (Virtual ones, on the other hand, /would/ mean a weird bug like
> described above.)

When you have 4G ram installed, the mmio could take [3G,4G).
ram range will be [0,3G), [4G, 5G).

Yinghai
