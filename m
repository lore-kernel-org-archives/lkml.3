Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab3JFMp6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 08:45:58 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:45884 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046Ab3JFMpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 08:45:55 -0400
Message-ID: <73b57dda33c9204f1cea02687f24807a.squirrel@www.mm-sol.com>
In-Reply-To: <CAJAp7OjvU2mi_TDiA5d-ut-Q9fHvKSbW_LfdpQGSTprsyPDU0g@mail.gmail.com>
References: <1380301041-26405-1-git-send-email-gdjakov@mm-sol.com>
    <1380301041-26405-3-git-send-email-gdjakov@mm-sol.com>
    <CAJAp7OjvU2mi_TDiA5d-ut-Q9fHvKSbW_LfdpQGSTprsyPDU0g@mail.gmail.com>
Date: Sun, 6 Oct 2013 15:45:53 +0300
Subject: Re: [PATCH v6 2/2] mmc: sdhci-msm: Initial support for MSM chipsets
From: "Georgi Djakov" <gdjakov@mm-sol.com>
To: "Bjorn Andersson" <bjorn@kryo.se>
Cc: "Georgi Djakov" <gdjakov@mm-sol.com>, linux-mmc@vger.kernel.org,
        "Chris Ball" <cjb@laptop.org>,
        "Grant Likely" <grant.likely@linaro.org>,
        "Rob Herring" <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        mark.rutland@arm.com, swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob@landley.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "Asutosh Das" <asutoshd@codeaurora.org>,
        "Venkat Gopalakrishnan" <venkatg@codeaurora.org>,
        "Sahitya Tummala" <stummala@codeaurora.org>,
        "Subhash Jadavani" <subhashj@codeaurora.org>
User-Agent: SquirrelMail/1.4.23 [SVN]
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

> Hi Georgi,
>
> Thanks for working on this, unfortunately it seems like I need to port
> the rpm regulators to be able to test this.
> But I did find that...
>

Yes, the regulators support is still missing upstream. Until then, a basic
testing can be done by bypassing the regulators init part in order to use
the power on defaults for regulators and maybe also clocks.

> On Fri, Sep 27, 2013 at 9:57 AM, Georgi Djakov <gdjakov@mm-sol.com> wrote:
>> ...
>> +static irqreturn_t sdhci_msm_pwr_irq(int irq, void *data)
>> +{
>> +       struct sdhci_msm_host *msm_host = (struct sdhci_msm_host *)data;
>> ...
>> +static int sdhci_msm_probe(struct platform_device *pdev)
>> +{
>> +       struct sdhci_host *host;
>> +       struct sdhci_msm_host *msm_host;
>> ...
>> +       ret = devm_request_threaded_irq(&pdev->dev, msm_host->pwr_irq,
>> NULL,
>> +                                       sdhci_msm_pwr_irq, IRQF_ONESHOT,
>> +                                       dev_name(&pdev->dev), host);
>> ...
>
> ...sdhci_msm_pwr_irq() expects the data pointer to be msm_host, not
> sdhci_host, so right now I only get a panic. So I suspect you mean
> msm_host as the last param here.

Yes, you are right, I have also noticed this and it is fixed in the next
version which i will be posting in the next few days. Thanks!

BR,
Georgi

