Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab3IZChk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:37:40 -0400
Received: from void.printf.net ([89.145.121.20]:49550 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab3IZChi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:37:38 -0400
From: Chris Ball <cjb@laptop.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Grant Grundler <grundler@chromium.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: core: remove issue_fn indirect function call
References: <1379611214-1089-1-git-send-email-grundler@chromium.org>
	<CAPDyKFr0h=uTz4xOAULLc0Ff23xB-xVuuk+XnBz_Uq5YMryHbA@mail.gmail.com>
	<87fvss2uh9.fsf@octavius.laptop.org>
Date: Wed, 25 Sep 2013 22:37:30 -0400
In-Reply-To: <87fvss2uh9.fsf@octavius.laptop.org> (Chris Ball's message of
	"Wed, 25 Sep 2013 22:21:38 -0400")
Message-ID: <8738os2tqt.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 25 2013, Chris Ball wrote:
> Hi,
>
> On Fri, Sep 20 2013, Ulf Hansson wrote:
>> On 19 September 2013 19:20, Grant Grundler <grundler@chromium.org> wrote:
>>> struct mmc_queue defines issue_fn as an indirect function call.
>>> issue_fn field only gets set to mmc_blk_issue_rq and only gets
>>> invoked immediately after calling blk_fetch_request().
>>> Don't bother with indirect function call - it's pointless and just
>>> obfuscates the code.
>>>
>>> Signed-off-by: Grant Grundler <grundler@chromium.org>
>>
>> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
>
> Thanks, pushed to mmc-next for 3.13.

Have dropped this, it's breaking my build:

/home/cjb/git/mmc/drivers/mmc/card/block.c:1955:12: warning: ‘mmc_blk_issue_rq’ defined but not used [-Wunused-function]
/home/cjb/git/mmc/drivers/mmc/card/queue.c: In function ‘mmc_queue_thread’:
/home/cjb/git/mmc/drivers/mmc/card/queue.c:70:4: error: implicit declaration of function ‘mmc_blk_issue_rq’ [-Werror=implicit-function-declaration]

Grant, please could you take a look and resubmit?

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
