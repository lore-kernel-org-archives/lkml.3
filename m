Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab3FROOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:14:53 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:39250 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932868Ab3FROOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:14:52 -0400
X-Greylist: delayed 732 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Jun 2013 10:14:52 EDT
X-Sasl-enc: aWS9W2BAA/LrcQRDP2uR9UbDB1cnqa+2hnuPphqSf206 1371564151
Message-ID: <51C06875.8080208@ladisch.de>
Date: Tue, 18 Jun 2013 16:02:29 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Wei Yongjun <weiyj.lk@gmail.com>, yongjun_wei@trendmicro.com.cn,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALSA: firewire: fix error return code in scs_probe()
References: <CAPgLHd-HMw40igirFvFHtN3HNy2utXHVAVERxKQ-vwF9ecUaSw@mail.gmail.com>
In-Reply-To: <CAPgLHd-HMw40igirFvFHtN3HNy2utXHVAVERxKQ-vwF9ecUaSw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wei Yongjun wrote:
> Fix to return -ENOMEM in the kmalloc() error handling
> case instead of 0, as done elsewhere in this function.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Clemens Ladisch <clemens@ladisch.de>

>  	scs->buffer = kmalloc(HSS1394_MAX_PACKET_SIZE, GFP_KERNEL);
> -	if (!scs->buffer)
> +	if (!scs->buffer) {
> +		err = -ENOMEM;
>  		goto err_card;
> +	}
