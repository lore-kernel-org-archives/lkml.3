Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaCANFJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 08:05:09 -0500
Received: from smtp-out-186.synserver.de ([212.40.185.186]:1063 "EHLO
	smtp-out-167.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752429AbaCANFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 08:05:07 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 7575
Message-ID: <5311DB1E.30008@metafoo.de>
Date: Sat, 01 Mar 2014 14:05:34 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Xiubo Li <Li.Xiubo@freescale.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCHv2 2/3] ASoC: io: New signature for snd_soc_codec_set_cache_io()
References: <1393578267-18255-1-git-send-email-Li.Xiubo@freescale.com> <1393578267-18255-3-git-send-email-Li.Xiubo@freescale.com> <20140301043458.GR29849@sirena.org.uk>
In-Reply-To: <20140301043458.GR29849@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2014 05:34 AM, Mark Brown wrote:
> On Fri, Feb 28, 2014 at 05:04:26PM +0800, Xiubo Li wrote:
>> Now that all users have been converted to regmap and the config.reg_bits
>> and config.val_bits can be setted by each user through regmap core API.
>> So these two params are redundant here.
>
> Actually, I think the way to fix the issue with CODECs doing I/O in
> probe is to provide a way for drivers to specify a regmap when
> registering the CODEC (rather than during probe) and then move the
> initialisation of the regmap before the probe function is called.  That
> would make set_cache_io() go away entirely.

Yep, that's actually my preference as well.

