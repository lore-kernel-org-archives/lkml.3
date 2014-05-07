Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbaEGFce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 01:32:34 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:43342 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbaEGFcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 01:32:33 -0400
MIME-Version: 1.0
In-Reply-To: <1399439776-18535-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1399439776-18535-1-git-send-email-bjorn.andersson@sonymobile.com>
Date: Tue, 6 May 2014 22:32:32 -0700
Message-ID: <CAJAp7OgiG-F-kaSXBC1iYG2rESH=Ta8k=pODFCF7_Yb0ANpdZA@mail.gmail.com>
Subject: Re: [PATCH] ARM: zImage: Allow DTB to override broken ATAG_MEM
From: Bjorn Andersson <bjorn@kryo.se>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2014 at 10:16 PM, Bjorn Andersson
<bjorn.andersson@sonymobile.com> wrote:
[...]
> +static int fdt_overrides_atag_mem(void *fdt)
> +{
> +       const char *memory;
> +       int len = 0;
> +
> +       memory = getprop(fdt, "/memory", "reg", &len);
> +       if (memory) {
> +               while (len--) {
> +                       if (*memory != '\0')

Sorry, this is of course supposed to be:
                       if (*memory++ != '\0')

> +                               return 1;
> +               }
> +       }
> +
> +       return 0;
> +}

Regards,
Bjorn
