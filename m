Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab3A2P12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 10:27:28 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:42777 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757354Ab3A2P1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 10:27:25 -0500
MIME-Version: 1.0
In-Reply-To: <20130129052247.GH2239@intel.com>
References: <1359371060-9044-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x==psH4fYmr_MxwO8vjYb=sWk=V7Vs8fs_-6U00gmiko_w@mail.gmail.com>
	<20130129052247.GH2239@intel.com>
Date: Tue, 29 Jan 2013 20:57:24 +0530
X-Google-Sender-Auth: AIYf_hfJtbQ-fzG3xJltMLAXqyI
Message-ID: <CAOh2x=nTJ1iz9aoR8VrkE5A+iaLMMbvFeebGPsO8KWRpDLw7=A@mail.gmail.com>
Subject: Re: [PATCH] dw_dmac: adjust slave_id accordingly to request line base
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 10:52 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> We had a discusssion about this with Andy as well. The thing is that there
> is no way in current resource to pass DMA request line numbers supported by
> the controller to the driver in a generic way. We on the other hand have to
> deal this somehow as we have a shared DMA controller on Lynxpoint where the
> offset will start from 16 (but it might be something else as well).
>
> Is there something which limits the usage of IORESOUCE_DMA to be only
> usable for ISA DMA channels?

Andy,

Why do we need this request_line_base? Why not program the actual value
directly into the slave structure (base + offset)?

In case it is required, add it in platform data field or can add DT
binding for it.

--
viresh
