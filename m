Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbaKTPKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:10:41 -0500
Received: from mail.kernel.org ([198.145.19.201]:40152 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbaKTPKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:10:39 -0500
MIME-Version: 1.0
In-Reply-To: <1415990361-8897-1-git-send-email-sboyd@codeaurora.org>
References: <1415990361-8897-1-git-send-email-sboyd@codeaurora.org>
Date: Thu, 20 Nov 2014 07:10:35 -0800
Message-ID: <CAMAWPa8m5Ey6ee8tK8n8g7T6XL7=ZfLzrQgbW9-2iPVWnUfigw@mail.gmail.com>
Subject: Re: [PATCH] tty: serial: msm_serial: Don't require DT aliases
From: Kevin Hilman <khilman@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Frank Rowand <frowand.list@gmail.com>, linux-serial@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Tyler Baker <tyler.baker@linaro.org>,
        Kevin Hilman <khilman@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

On Fri, Nov 14, 2014 at 10:39 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> If there isn't a DT alias then of_alias_get_id() will return
> -ENODEV. This will cause the msm_serial driver to fail probe,
> when we want to keep the previous behavior where we generated a
> dynamic line number at probe time. Restore this behavior by
> generating a dynamic id if the line number is still negative
> after checking for an alias or in the non-DT case looking at the
> .id field of the platform device.
>
> Reported-by: Kevin Hilman <khilman@kernel.org>
> Tested-by: Kevin Hilman <khilman@linaro.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Can you add this to tty-next.  Without this, all the ARM/qcom boards
do not boot in linux-next.

Thanks,

Kevin
