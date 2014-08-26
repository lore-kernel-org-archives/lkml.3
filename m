Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934838AbaHZKOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:14:49 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:3868 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932835AbaHZKOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:14:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 26 Aug 2014 03:04:46 -0700
Message-ID: <53FC5DF0.2040205@nvidia.com>
Date: Tue, 26 Aug 2014 15:44:08 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Arnout Vandecappelle (Essensium/Mind)" <arnout@mind.be>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH v2] tps65910: Work around silicon erratum SWCZ010
References: <1408709666-5927-1-git-send-email-arnout@mind.be> <1408721456-8101-1-git-send-email-arnout@mind.be>
In-Reply-To: <1408721456-8101-1-git-send-email-arnout@mind.be>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because this patch is dropped from Mark's tree, here is opportunity to 
revisit patch.

On Friday 22 August 2014 09:00 PM, Arnout Vandecappelle (Essensium/Mind) 
wrote:
>  From http://www.ti.com/lit/pdf/SWCZ010 :
>
>
> Workaround:
> Repeat I2C access.

> A simpler workaround is to make a dummy transfer just before the first
> access to the tps65910 chip. This can be done unconditionally.
> >id = chip_id;
>   
> +	/* Work around silicon erratum SWCZ010: the tps65910 may miss the
> +	 * first I2C transfer. So issue a dummy transfer before the first
> +	 * real transfer.
> +	 */
> +	i2c_master_send(i2c, "", 1);

I think dummy read is more safe operation than dummy write.
Dummy write can create the write on any register which can damage the 
critical settings or it may be possible that it will be incomplete 
calls. Datasheet has not been explained this clearly.


>   	

