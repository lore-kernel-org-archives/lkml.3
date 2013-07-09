Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab3GIVR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 17:17:56 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:49846 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab3GIVRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 17:17:53 -0400
MIME-Version: 1.0
X-Originating-IP: [212.159.75.221]
In-Reply-To: <1373391071-6312-3-git-send-email-dianders@chromium.org>
References: <1373391071-6312-1-git-send-email-dianders@chromium.org>
	<1373391071-6312-3-git-send-email-dianders@chromium.org>
Date: Tue, 9 Jul 2013 22:17:51 +0100
X-Google-Sender-Auth: w-SStYBBM5iWCT2BAjMfq9NbADg
Message-ID: <CAAG0J9_FbJYRrR=8GgHCvMDSbwfwXic81TJfchnv5UM798RB_g@mail.gmail.com>
Subject: Re: [PATCH 2/5] mmc: dw_mmc: Add suspend/resume callbacks; disable
 irq during suspend
From: James Hogan <james.hogan@imgtec.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Ball <cjb@laptop.org>, Olof Johansson <olof@lixom.net>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-mmc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On 9 July 2013 18:31, Doug Anderson <dianders@chromium.org> wrote:
> On some platforms (like exynos5420) the dw_mmc controller may be in a
> strange state after we wake up from sleep.  Add callbacks to allow for
> dealing with these quirks.  Prevent interrupts from firing when we're
> suspended since this strange state may cause interrupts to fire.
>
> In my case I saw the WAKEUP_INT interrupt firing upon resume and
> needed to add some code to handle this.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Would it make sense to take advantage of the {suspend,resume}_noirq
power management callbacks to clear that WAKEUP_INT before interrupts
are re-enabled, rather than explicitly disabling and enabling the
interrupt at the suspend/resume stage?

Cheers
James
