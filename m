Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbaEIT6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 15:58:48 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:64337 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757229AbaEIT6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 15:58:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit and 32-bit ports
Date: Fri, 09 May 2014 21:58:43 +0200
Message-ID: <9233735.5FfZoZovqP@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140509191914.GA7286@jtriplet-mobl1>
References: <20140509191914.GA7286@jtriplet-mobl1>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:GxrYCPArlRLhpSsO3PKa5S3573zuO2Md1PeEfbD6YuK
 zMbHGVSo11RJjzzEVlzfri/bGs2O5zO0/BbvS4E1puI9jj7/7l
 AvRc5pGbPie/fwYNj70t2jlvDlgweog8+FP9mb2GqBXmQL3Gvk
 dgj1emfVLSMMVcjt9XbGKOi4yxjLY1GcQQ2LzLMmnQIcV2VOwE
 Mr37ZTDvnXMyR1JA+EHgtuJKZZBtfpOfirYlMMMtRB6cLBSQwz
 CaItT9ov/oP8eCW9EZccKO6/pqwjkAo9RQApka8JX2JhLzzmk+
 mum2MjGVtNGGgGyoFd9f8AuOEG+D1PAPp41bOWzPPZ4x0tQf6w
 blbejZLqd9HuOT67cxVQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 May 2014 12:19:16 Josh Triplett wrote:

> +	if (!access_ok(VERIFY_WRITE, buf, count))
> +		return -EFAULT;
> +	if (port > 65535)
> +		return 0;

This should probably test against IO_SPACE_LIMIT, which may be zero,
something larger than 65536 or even ULONG_MAX, depending on the
architecture.

In cases where this IO_SPACE_LIMIT is zero or ULONG_MAX, we should
probably disallow access completely. The former case is for architectures
that don't have any I/O ports, the other is either a mistake, or is
used when inb is defined as readb, and the port numbers are just virtual
addresses.

	Arnd
