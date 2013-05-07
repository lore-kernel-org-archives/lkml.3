Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101Ab3EGAIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 20:08:34 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59447 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757466Ab3EGAIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 20:08:30 -0400
Message-ID: <518844A4.8040203@ti.com>
Date: Mon, 6 May 2013 19:02:44 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jassi Brar <jassisinghbrar@gmail.com>
CC: <loic.pallardy@st.com>, <arnd@arndb.de>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: Re: [PATCHv2 0/4] mailbox: Common API
References: <1367824946-6160-1-git-send-email-jaswinder.singh@linaro.org>
In-Reply-To: <1367824946-6160-1-git-send-email-jaswinder.singh@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jassi,

On 05/06/2013 02:22 AM, Jassi Brar wrote:
> Hello,
>   I have made the implementation look more proper. Also made some changes
> suggested by Suman. Changes since V1:
> 
> * Delete timer upon mailbox release
> * Filled in the stub ipc_links_unregister()
> * Check kzalloc return for errors.
> * Add the controller driver for OMAP2 class. I have taken the patch
>   for mailbox's hwmod from Suman's. The clients are yet to be converted
>   but this should be enough to convey the idea that the API could
>   work for OMAP as well. If I had access to STE documentation, I might
>   have done some implementation for U8500 as well.

The bug fixes in this series look good in general. I have provided my
design comments in the previous RFC thread [1] still, since the overall
changes here are not that much different from the RFC.

Thanks for prototyping the OMAP portions, it demonstrates the adaptation
to the new API, but I have to take a step approach in moving the current
OMAP mailbox code and making incremental changes on top of it. The
mailbox driver is the bottom-most layer in our IPC stacks, so changes at
this layer are very critical to the functional behavior.

regards
Suman

[1] http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg429678.html


