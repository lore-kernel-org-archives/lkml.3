Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935423Ab3DIXzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 19:55:36 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:43522 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935092Ab3DIXzf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 19:55:35 -0400
MIME-Version: 1.0
In-Reply-To: <1365501657-4213-6-git-send-email-serban.constantinescu@arm.com>
References: <1365501657-4213-1-git-send-email-serban.constantinescu@arm.com>
	<1365501657-4213-6-git-send-email-serban.constantinescu@arm.com>
Date: Tue, 9 Apr 2013 16:55:35 -0700
Message-ID: <CAMP5Xgf9fcm0WchtSHWQMeS4upguZRuCyt4-=UK1Gpc28+8vDQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] staging: android: binder: fix BC_FREE_BUFFER ioctl declaration
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 3:00 AM, Serban Constantinescu
<serban.constantinescu@arm.com> wrote:
> BinderDriverCommands mirror the ioctl usage. Thus the size of the
> structure passed through the interface should be used to generate the
> ioctl No.
>
> The change reflects the type being passed from the user space-a pointer
> to a binder_buffer. This change should not affect the existing 32bit
> user space since BC_FREE_BUFFER is computed as:
>
>    #define _IOW(type,nr,size)         \
>       ((type) << _IOC_TYPESHIFT) |    \
>       ((nr)   << _IOC_NRSHIFT) |      \
>       ((size) << _IOC_SIZESHIFT))
>
> and for a 32bit compiler BC_FREE_BUFFER will have the same computed
> value. This change will also ease our work in differentiating
> BC_FREE_BUFFER from COMPAT_BC_FREE_BUFFER.
>
> The change does not affect existing 32bit ABI.
>
> Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>

Acked-by:  Arve Hjønnevåg <arve@android.com>

--
Arve Hjønnevåg
