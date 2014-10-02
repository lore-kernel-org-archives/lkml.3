Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaJBJ2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 05:28:54 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:59987 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaJBJ2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 05:28:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, Carlo Caione <carlo@caione.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>
Subject: Re: [PATCH 1/6] ARM: meson: add meson8 machine definition
Date: Thu, 02 Oct 2014 11:28:14 +0200
Message-ID: <6568653.UtyvOjrQBb@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412198986-26534-2-git-send-email-b.galvani@gmail.com>
References: <1412198986-26534-1-git-send-email-b.galvani@gmail.com> <1412198986-26534-2-git-send-email-b.galvani@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:AUvGD0W6rRKREhqHdNZ/XYtXo3snX0B3+eGNrHuhcLi
 /Lx4txXVk0bxgXt4i2tRqearOD88cO0fgsXnffRCNMTzykDSc9
 stgjcEiB4Hvju2jZOwNa/yypGi0wwSOf5eaTsMfP+j+nKutSgE
 CZCjxiRl0HJL8kqpadSj6Ne8sCeshGzVBS9BvghHuCfc5Sl1Ba
 SdQYsFTFm2xtfTUdhHwSv4qJ2FZGYAQJvd5NM2FIg/HYIjU9ed
 sXMXar8aSDRj9ZM81LKECyY3nDukU/EgdA5K6I/+7jK1+DZm0B
 YQxPDBBcPz5wd+nlx5F6BSOfu9BQ63e2px5XZiixSKa7s7UNrs
 QQz0PODDHpCkpvir9uGc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2014 23:29:41 Beniamino Galvani wrote:
>  DT_MACHINE_START(AML8726_MX, "Amlogic Meson6 platform")
>         .dt_compat      = m6_common_board_compat,
>  MACHINE_END
>  
> +DT_MACHINE_START(MESON8, "Amlogic Meson8 platform")
> +       .dt_compat      = m8_common_board_compat,
> +MACHINE_END

One more thing: since this is a cortex-a9, don't you have to enable
the l2x0 cache controller explicitly? I think you need a
".l2c_aux_mask   = ~0," entry here.

	Arnd
