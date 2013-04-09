Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935001Ab3DIXxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 19:53:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63619 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759219Ab3DIXxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 19:53:15 -0400
MIME-Version: 1.0
In-Reply-To: <1365501657-4213-5-git-send-email-serban.constantinescu@arm.com>
References: <1365501657-4213-1-git-send-email-serban.constantinescu@arm.com>
	<1365501657-4213-5-git-send-email-serban.constantinescu@arm.com>
Date: Tue, 9 Apr 2013 16:53:14 -0700
Message-ID: <CAMP5Xgfb2NYN8j16XKx3hrvk1gnRCX+yx2Uk_fxSE=OM74y5fQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] staging: android: binder: fix BINDER_SET_MAX_THREADS
 declaration
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 3:00 AM, Serban Constantinescu
<serban.constantinescu@arm.com> wrote:
> This change will fix the BINDER_SET_MAX_THREADS ioctl to use __s32
> instead of size_t for setting the max threads. Thus using the same
> handler for 32 and 64bit kernels.
>
> This value is stored internally in struct binder_proc as an int and
> is set to 15 on open_binder() in the libbinder API (thus no need for
> a 64bit size_t on 64bit platforms).
>

Why switch to a signed type?
