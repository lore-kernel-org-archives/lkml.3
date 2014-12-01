Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464AbaLAUam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:30:42 -0500
Received: from smtp-out-249.synserver.de ([212.40.185.249]:1072 "EHLO
	smtp-out-249.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158AbaLAUal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:30:41 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 13028
Message-ID: <547CCFF7.2000205@metafoo.de>
Date: Mon, 01 Dec 2014 21:30:47 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Timur Tabi <timur@tabi.org>, Arnd Bergmann <arnd@arndb.de>
CC: linuxppc-dev@lists.ozlabs.org, Mark Brown <broonie@kernel.org>,
        alsa-devel@alsa-project.org, Jiada Wang <jiada_wang@mentor.com>,
        linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        nicoleotsuka@gmail.com, tiwai@suse.de, Li.Xiubo@freescale.com,
        Markus Pargmann <mpa@pengutronix.de>
Subject: Re: [alsa-devel] [PATCH] ASoC: fsl_ssi: free irq before irq_dispose_mapping()
References: <1417402251-6596-1-git-send-email-jiada_wang@mentor.com> <2547588.Qc4F2IfZke@wuerfel> <547CC89F.1030205@tabi.org> <3401240.VsRpsiV8WN@wuerfel> <547CCB78.5090007@tabi.org>
In-Reply-To: <547CCB78.5090007@tabi.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2014 09:11 PM, Timur Tabi wrote:
> On 12/01/2014 02:01 PM, Arnd Bergmann wrote:
>>> >Does this mean that fsl_ssi.c should not be calling
>>> >irq_of_parse_and_map?  How else should it get the IRQ?
>> platform_get_irq()
>
> Ok, but that function also calls irq_create_of_mapping().  So it still
> appears that the only way to get the IRQ is to map it, but then we can't use
> devm_request_irq().
>

Hm... that's new. But it's not really a driver issue anymore if it is done 
in the core. So I guess for now just use platform_get_irq() and ignore the 
other issue.
