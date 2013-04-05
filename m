Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab3DEC2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 22:28:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35987 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932505Ab3DEC2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 22:28:13 -0400
From: Thomas Renninger <trenn@suse.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Tang Chen <tangchen@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/22] x86, ACPI, numa: Parse numa info early
Date: Fri, 05 Apr 2013 04:28:10 +0200
Message-ID: <2084826.BkfVPXvXDZ@skinner.arch.suse.de>
Organization: SUSE Products GmbH
User-Agent: KMail/4.10 (Linux/3.7.10-1.1-desktop; KDE/4.10.0; x86_64; ; )
In-Reply-To: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
References: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 04, 2013 04:46:04 PM Yinghai Lu wrote:
> One commit that tried to parse SRAT early get reverted before v3.9-rc1.
> 
> | commit e8d1955258091e4c92d5a975ebd7fd8a98f5d30f
> | Author: Tang Chen <tangchen@cn.fujitsu.com>
> | Date:   Fri Feb 22 16:33:44 2013 -0800
> | 
> |    acpi, memory-hotplug: parse SRAT before memblock is ready
> 
> It broke several things, like acpi override and fall back path etc.
> 
> This patchset is clean implementation that will parse numa info early.

I tried acpi table overriding, but it did not work for me.
In your tree there seem to miss acpi initrd overriding doku:
Documentation/acpi/initrd_table_override.txt
?
And your tree is 3.6.0-rc6-default+ based, right?

I tried it like that:
mkdir -p kernel/firmware/acpi
cp dsdt.aml kernel/firmware/acpi
find kernel | cpio -H newc --create > /boot/instrumented_initrd
cat /boot/initrd >>/boot/instrumented_initrd

modified /boot/grub/menu.lst and pointed to /boot/instrumented_initrd

-> no override messages in dmesg, no overriding happened at all.

Did I oversee something?

    Thomas
