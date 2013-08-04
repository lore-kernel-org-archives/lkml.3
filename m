Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab3HDSRj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 14:17:39 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:44939 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab3HDSRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 14:17:37 -0400
MIME-Version: 1.0
In-Reply-To: <1375638206-5916-1-git-send-email-rupesh.gujare@atmel.com>
References: <1375638206-5916-1-git-send-email-rupesh.gujare@atmel.com>
Date: Sun, 4 Aug 2013 21:17:37 +0300
Message-ID: <CAJL_dMvs3-r+cKxNzG=i=TczwXwbcie0B+UbU7ykQ2K6aDu3+Q@mail.gmail.com>
Subject: Re: [PATCH] staging: ozwpan: Fix build warning.
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: devel@linuxdriverproject.org, Wu Fengguang <fengguang.wu@intel.com>,
        linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why do not use div_u64() ?

[quote]unsigned 64bit divide with 32bit divisor

This is the most common 64bit divide and should be used if possible,
as many 32bit archs can optimize this variant better than a full 64bit
divide.
[/quote]

> -               ep->credit += timespec_to_ns(&delta) / NSEC_PER_MSEC;
> +               ep->credit += div64_u64(timespec_to_ns(&delta), NSEC_PER_MSEC);
