Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbaA1URm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 15:17:42 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:41393 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112AbaA1URi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 15:17:38 -0500
MIME-Version: 1.0
In-Reply-To: <20140128182230.GO15937@n2100.arm.linux.org.uk>
References: <1390590670-25901-1-git-send-email-yinghai@kernel.org>
	<1390590670-25901-4-git-send-email-yinghai@kernel.org>
	<CAOesGMh7+SzLTfyPomnB_Q_wft+RC+F3tx-Ow1TdSmHiSwrKcw@mail.gmail.com>
	<CAGa+x87jJep_TSG70wAr5M-Ce7soPyr4SBdPqyo2ENZ2DYcqkA@mail.gmail.com>
	<CAE9FiQU_vZo40cje_XJXSxuKW-JL6H-8rAazwOw1O-ewcV+C5g@mail.gmail.com>
	<52E7E776.30909@ti.com>
	<20140128182230.GO15937@n2100.arm.linux.org.uk>
Date: Tue, 28 Jan 2014 12:17:37 -0800
X-Google-Sender-Auth: -Y2_9iJIt9NmEp4AA9ZCbrJ9CNg
Message-ID: <CA+55aFx8QkcWdq7hqi+nypZ5ePFBHO5NhBsnTG+AgJLhWodVYg@mail.gmail.com>
Subject: Re: [PATCH 1/3] memblock, nobootmem: Add memblock_virt_alloc_low()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Yinghai Lu <yinghai@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Hansen <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 10:22 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
>
> Hence, having ARCH_LOW_ADDRESS_LIMIT set to 4GB-1 by default seems to be
> completely rediculous - and presumably this also fails on x86_32 if it
> returns memory up at 4GB.

Agreed. That looks broken even on x86-32. The low address limit is not
even *close* to 4GB in general on 32-bit, since you not only have the
TASK_SIZE, you have the kmap and the vmalloc area. On x86-32,
ARCH_LOW_ADDRESS_LIMIT should be MAXMEM, which iirc is somewhere
around 890MB or so. Not 4G.

                    Linus
