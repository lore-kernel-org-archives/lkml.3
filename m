Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab3JFFvg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 01:51:36 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:53824 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab3JFFvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 01:51:33 -0400
MIME-Version: 1.0
In-Reply-To: <1380301041-26405-3-git-send-email-gdjakov@mm-sol.com>
References: <1380301041-26405-1-git-send-email-gdjakov@mm-sol.com>
	<1380301041-26405-3-git-send-email-gdjakov@mm-sol.com>
Date: Sat, 5 Oct 2013 22:51:32 -0700
Message-ID: <CAJAp7OjvU2mi_TDiA5d-ut-Q9fHvKSbW_LfdpQGSTprsyPDU0g@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] mmc: sdhci-msm: Initial support for MSM chipsets
From: Bjorn Andersson <bjorn@kryo.se>
To: Georgi Djakov <gdjakov@mm-sol.com>
Cc: linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        mark.rutland@arm.com, swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob@landley.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Asutosh Das <asutoshd@codeaurora.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Sahitya Tummala <stummala@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Georgi,

Thanks for working on this, unfortunately it seems like I need to port
the rpm regulators to be able to test this.
But I did find that...

On Fri, Sep 27, 2013 at 9:57 AM, Georgi Djakov <gdjakov@mm-sol.com> wrote:
> ...
> +static irqreturn_t sdhci_msm_pwr_irq(int irq, void *data)
> +{
> +       struct sdhci_msm_host *msm_host = (struct sdhci_msm_host *)data;
> ...
> +static int sdhci_msm_probe(struct platform_device *pdev)
> +{
> +       struct sdhci_host *host;
> +       struct sdhci_msm_host *msm_host;
> ...
> +       ret = devm_request_threaded_irq(&pdev->dev, msm_host->pwr_irq, NULL,
> +                                       sdhci_msm_pwr_irq, IRQF_ONESHOT,
> +                                       dev_name(&pdev->dev), host);
> ...

...sdhci_msm_pwr_irq() expects the data pointer to be msm_host, not
sdhci_host, so right now I only get a panic. So I suspect you mean
msm_host as the last param here.

Regards,
Bjorn
