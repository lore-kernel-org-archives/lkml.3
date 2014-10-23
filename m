Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbaJWHwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 03:52:25 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:54024 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbaJWHwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 03:52:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Chenhui Zhao <chenhui.zhao@freescale.com>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, leoli@freescale.com, Jason.Jin@freescale.com
Subject: Re: [PATCH v2 2/2] arm: pm: add deep sleep support for LS1
Date: Thu, 23 Oct 2014 09:52:13 +0200
Message-ID: <10927226.rVoqeXCnhH@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414037773-7735-2-git-send-email-chenhui.zhao@freescale.com>
References: <1414037773-7735-1-git-send-email-chenhui.zhao@freescale.com> <1414037773-7735-2-git-send-email-chenhui.zhao@freescale.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:vL9oCmjRGvMEdfXwM58ZL5LttH4/mlRFacm2V2vfT8+
 2tBb2f3R+HWKulopprVbR2QuN+erTVW8qRPSvV9Z1PlDfaOcCe
 2c9GMR9txPvOCU2gr2BsdIiV3b4KKIxgLuU2XwmQoQlv3q6YBy
 3ckgVxrjZ7Gq/312qK4MCuHCb/ZcHV6QDeGDuhkMleundZ7Ke2
 M/VTIUoDecGzUR9k2nzQLQHz3jKK0KXwFdzHH9FhoaxLhj3Qs6
 w7n1loaec1iGxbPLHbvApPTbp3IzP39Dfuf6opp5vEg0lWOKTR
 zE8UMAuAPa8jXtl+sDXNmtLuymZm+2ZczdOaoT1gXOIdSAjZo6
 0eRoLKdUvNHmcK4L/20o=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 October 2014 12:16:13 Chenhui Zhao wrote:
> +extern void ls1_do_deepsleep(unsigned long addr);
> +extern void ls1_start_fsm(void);
> +extern void ls1_deepsleep_resume(void);
> +extern void ls1021a_set_secondary_entry(void);
> +extern int ls1_sram_code_size;
> +extern void fsl_epu_setup_default(void __iomem *epu_base);
> +

Please move these into a header file out of principle. I realize they
are defined in an assembly file, so the change won't actually add
any type safety as it would for functions defined in C files, but it's
better to be consistent.

	Arnd
