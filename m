Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbaAWPzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 10:55:54 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:38886 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaAWPzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 10:55:53 -0500
Date: Thu, 23 Jan 2014 15:55:45 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Ludovic Barre <ludovic.barre@st.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, computersforpeace@gmail.com,
        Angus.Clark@st.com, DCG_UPD_stlinux_kernel@list.st.com,
        olivier.clergeaud@st.com
Subject: Re: [PATCH RESEND v4 01/37] mtd: st_spi_fsm: Allocate resources and
 register with MTD framework
Message-ID: <20140123155545.GH8586@lee--X1>
References: <1390473085-24626-1-git-send-email-lee.jones@linaro.org>
 <1390473085-24626-2-git-send-email-lee.jones@linaro.org>
 <52E12434.7030000@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52E12434.7030000@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >+	fsm->region = devm_request_mem_region(&pdev->dev, res->start,
> >+					      resource_size(res), pdev->name);
> >+	if (!fsm->region) {
> >+		dev_err(&pdev->dev,
> >+			"Failed to reserve memory region [0x%08x-0x%08x]\n",
> >+			res->start, res->end);
> >+		return -EBUSY;
> >+	}
> >+
> >+	fsm->base = devm_ioremap_nocache(&pdev->dev,
> >+					 res->start, resource_size(res));
> >+	if (!fsm->base) {
> >+		dev_err(&pdev->dev, "Failed to ioremap [0x%08x]\n", res->start);
> >+		return -EINVAL;
> >+	}
> >+
> you can replace  "devm_request_mem_region" & "devm_ioremap_nocache"
> by "devm_ioremap_resource"

Yes, that looks entirely reasonable, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
