Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265AbaLRPID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 10:08:03 -0500
Received: from smtp-out-207.synserver.de ([212.40.185.207]:1111 "EHLO
	smtp-out-207.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaLRPIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 10:08:01 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 22897
Message-ID: <5492EDC9.5000401@metafoo.de>
Date: Thu, 18 Dec 2014 16:07:53 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Mike Looijmans <mike.looijmans@topic.nl>
CC: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] sound/soc/adi/axi-spdif.c: Support programmable master
 clock
References: <54893D3D.8050100@topic.nl> <1418283847-25673-1-git-send-email-mike.looijmans@topic.nl>
In-Reply-To: <1418283847-25673-1-git-send-email-mike.looijmans@topic.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2014 08:44 AM, Mike Looijmans wrote:
> If the master clock supports programmable rates, program it to generate
> the desired frequency. Only apply constraints when the clock is fixed.
> This allows proper clock generation for both 44100 and 48000 Hz based
> sampling rates if the platform supports it.
>
> The clock frequency must be set before enabling it. Enabling the clock
> was done in "startup", but that occurs before "hw_params" where the rate
> is known. Enabling a programmable clock without first setting a valid
> frequency may harm the system. Move the clock start to the hw_params
> routine, and keep track of whether the clock has been started, because
> shutdown may be called without having called hw_params first, and
> hw_params may be called multiple times.
> Starting the clock and enabling the SPDIF output AFTER programming the
> dividers is a more logical order anyway.
>
> To detect if the source clock is fixed, the driver calls clk_round_rate
> for two frequencies. If the results are equal, or if the call returns
> an error, the driver assumes the clock is fixed.
>
> Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks.
