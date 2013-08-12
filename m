Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751100Ab3HLRbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:31:36 -0400
Received: from mail-qe0-f47.google.com ([209.85.128.47]:34873 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3HLRbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:31:33 -0400
MIME-Version: 1.0
In-Reply-To: <000001ce9747$680a9800$381fc800$%jun@samsung.com>
References: <1375846138-15839-1-git-send-email-dbasehore@chromium.org>
	<000001ce9747$680a9800$381fc800$%jun@samsung.com>
Date: Mon, 12 Aug 2013 10:31:32 -0700
Message-ID: <CAD=FV=U69UONapHhy+LQ0cNe+G5SWmowvVnAWxcEP+CN_HOXkg@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Don't disable vmmc if keeping power in suspend
From: Doug Anderson <dianders@google.com>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: Derek Basehore <dbasehore@chromium.org>, Chris Ball <cjb@laptop.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seungwon and Derek,

On Mon, Aug 12, 2013 at 3:33 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> On Wed, August 07, 2013, Derek Basehore
>> If we keep power for suspend on a host for dw_mmc, don't disable vmmc-supply
>> regulator when suspending the host.
>
> I have a trivial comment.
> It would be better to add some macro for checking MMC_PM_KEEP_POWER.
> And I just wonder how the problem is silent. Origin code has stood up somewhat long.
> Did you see?
>
> Acked-by: Seungwon Jeon <tgih.jun@samsung.com>
>
> Thanks,
> Seungwon Jeon
>
>>
>> Signed-off-by: Derek Basehore <dbasehore@chromium.org>
>> Reviewed-by: Doug Anderson <dianders@chromium.org>
>> ---
>>  drivers/mmc/host/dw_mmc.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)

Though I reviewed this originally, I'd actually propose not landing it.

I've spent more time with the regulator code in dw_mmc and currently
believe that the regulators should be enabled / disabled in
MMC_POWER_UP / MMC_POWER_OFF.  When we do that then the mmc core will
handle MMC_PM_KEEP_POWER.  You can see my current thoughts on this in
<https://gerrit.chromium.org/gerrit/#/c/65263/>.  I will try to post
that upstream before too long, but feel free to let me know any
comments.

-Doug
