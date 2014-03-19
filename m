Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151AbaCSJwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 05:52:38 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:60894 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758966AbaCSJwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 05:52:36 -0400
MIME-Version: 1.0
Date: Wed, 19 Mar 2014 12:52:35 +0300
Message-ID: <CACVxJT_vYPeQqvDHT-TELb+EzcaE+YzTLnSUkBLVf_vm_zGCng@mail.gmail.com>
Subject: Re: [PATCH] avr32: replace simple_strtoul() with kstrtoul()
From: Alexey Dobriyan <adobriyan@gmail.com>
To: artagnon@gmail.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, hskinnemoen@gmail.com,
        egtvedt@samfundet.no
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - val = simple_strtoul(buf, &endp, 0);
> - if (endp == buf || val > 0x3f)
> - return -EINVAL;
> + ret = kstrtoul(buf, 0, &val);
> + if (ret)
> + return ret;
>   val = (val << 12) | (sysreg_read(PCCR) & 0xfffc0fff);

you removed 0x3f check

this conversion is not trivial as it seems
