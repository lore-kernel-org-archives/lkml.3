Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab3AYJHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 04:07:17 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:53682 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab3AYJHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 04:07:11 -0500
MIME-Version: 1.0
In-Reply-To: <CAHp75Vex-t=q4aQtBsJHiu-r8u98UDPvcbgQi3Z+42dkQWL+YA@mail.gmail.com>
References: <CAOh2x=kqEzw9cvg=WLpjEbF50aTKCUUVd9GzNg8PqtBx_BpYLg@mail.gmail.com>
	<1359032849-25551-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x=nnrEo69W7sBES85KgF0+WUy8Ouoq+SG1XiB54e7QLiow@mail.gmail.com>
	<1359104204.12502.101.camel@smile>
	<CAHp75Vex-t=q4aQtBsJHiu-r8u98UDPvcbgQi3Z+42dkQWL+YA@mail.gmail.com>
Date: Fri, 25 Jan 2013 14:37:10 +0530
Message-ID: <CAKohponpZa5Lzf-0p_porTuidL+LhZX3xrHzkwnC6ffTMchRQg@mail.gmail.com>
Subject: Re: [PATCH v3.5] dw_dmac: return proper residue value
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 January 2013 14:34, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> Okay, we have to have a protection here because get_sent reads two
> registers consequentially. This means we could end up with scenario
> with threads 1 and 2
>
> 1. read ctlhi
> 2. write ctlhi
> 2. write ctllo
> 1. read ctllo

Who is going to right on ctlhi/lo? we write to ctlhi/lo only when we program new
transfer. and that is not going to happen while we are in middle of a transfer.
