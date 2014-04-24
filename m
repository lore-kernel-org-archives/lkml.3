Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681AbaDXQtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:49:46 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:49559 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215AbaDXQtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:49:39 -0400
MIME-Version: 1.0
In-Reply-To: <1398354495-20782-6-git-send-email-iivanov@mm-sol.com>
References: <1398354495-20782-1-git-send-email-iivanov@mm-sol.com>
	<1398354495-20782-6-git-send-email-iivanov@mm-sol.com>
Date: Thu, 24 Apr 2014 13:49:38 -0300
Message-ID: <CAOMZO5COKimLjC0oYqgwSaEvSBUpoy9aP_P-ScU+ozh0KpsCoA@mail.gmail.com>
Subject: Re: [PATCH v7 05/20] usb: phy: msm: Migrate to Managed Device
 Resource allocation
From: Fabio Estevam <festevam@gmail.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 12:48 PM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:

> +       motg->vddcx = devm_regulator_get(motg->phy.dev, "HSUSB_VDDCX");
> +       if (IS_ERR(motg->vddcx)) {
> +               dev_err(motg->phy.dev, "unable to get hsusb vddcx\n");
> +               return PTR_ERR(motg->vddcx);
> +       }
> +
> +       motg->v3p3 = devm_regulator_get(motg->phy.dev, "HSUSB_3p3");
> +       if (IS_ERR(motg->v3p3)) {
> +               dev_err(motg->phy.dev, "unable to get hsusb 3p3\n");
> +               return PTR_ERR(motg->v3p3);
> +       }
> +
> +       motg->v1p8 = devm_regulator_get(motg->phy.dev, "HSUSB_1p8");
> +       if (IS_ERR(motg->v1p8)) {
> +               dev_err(motg->phy.dev, "unable to get hsusb 1p8\n");
> +               return PTR_ERR(motg->v1p8);
> +       }

It seems that calling devm_regulator_bulk_get() here would simplify
the code here.
