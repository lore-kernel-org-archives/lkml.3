Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbaKJEuc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 23:50:32 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56077 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751565AbaKJEua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 23:50:30 -0500
X-Sasl-enc: 5CZ4ONncRELu2aWsClkMi9eiMXq9Bub3SPcOFJWK1uj8 1415595028
Date: Mon, 10 Nov 2014 13:38:53 +0900
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 sound-asoc tree
Message-ID: <20141110043853.GA25797@kroah.com>
References: <20141110153132.259d49d9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110153132.259d49d9@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 03:31:32PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> sound/soc/intel/sst-haswell-pcm.c between commit 2e4f75919e5a ("ASoC:
> Intel: Add PM support to HSW/BDW PCM driver") from the sound-asoc tree
> and commit 3c1af8802e45 ("ASoC: intel: drop owner assignment from
> platform_drivers") from the driver-core tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc sound/soc/intel/sst-haswell-pcm.c
> index 7eb9afc9b33d,ad21e636edc6..000000000000
> --- a/sound/soc/intel/sst-haswell-pcm.c
> +++ b/sound/soc/intel/sst-haswell-pcm.c
> @@@ -1173,9 -899,6 +1173,8 @@@ static const struct dev_pm_ops hsw_pcm_
>   static struct platform_driver hsw_pcm_driver = {
>   	.driver = {
>   		.name = "haswell-pcm-audio",
> - 		.owner = THIS_MODULE,
>  +		.pm = &hsw_pcm_pm,
>  +
>   	},
>   
>   	.probe = hsw_pcm_dev_probe,


Fix looks good, thanks.

greg k-h
