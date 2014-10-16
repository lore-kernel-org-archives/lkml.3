Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaJPMBD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 08:01:03 -0400
Received: from smtp-out-102.synserver.de ([212.40.185.102]:1115 "EHLO
	smtp-out-102.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaJPMBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 08:01:01 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 12688
Message-ID: <543FB374.8020604@metafoo.de>
Date: Thu, 16 Oct 2014 14:00:52 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.8.1
MIME-Version: 1.0
To: Shuah Khan <shuahkh@osg.samsung.com>, m.chehab@samsung.com,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org, crope@iki.fi,
        olebowle@gmx.com, dheitmueller@kernellabs.com, hverkuil@xs4all.nl,
        ramakrmu@cisco.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, perex@perex.cz, tiwai@suse.de,
        prabhakar.csengg@gmail.com, tim.gardner@canonical.com,
        linux@eikelenboom.it
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-media@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH v2 5/6] sound/usb: pcm changes to use media
 token api
References: <cover.1413246370.git.shuahkh@osg.samsung.com> <cf1059cc2606f20d921e5691e3d59945a19a7871.1413246372.git.shuahkh@osg.samsung.com>
In-Reply-To: <cf1059cc2606f20d921e5691e3d59945a19a7871.1413246372.git.shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2014 04:58 PM, Shuah Khan wrote:
[...]
>   	switch (cmd) {
>   	case SNDRV_PCM_TRIGGER_START:
> +		err = media_get_audio_tkn(&subs->dev->dev);
> +		if (err == -EBUSY) {
> +			dev_info(&subs->dev->dev, "%s device is busy\n",
> +					__func__);

In my opinion this should not dev_info() as this is out of band error 
signaling and also as the potential to spam the log. The userspace 
application is already properly notified by the return code.

> +			return err;
> +		}
>   		err = start_endpoints(subs, false);
>   		if (err < 0)
>   			return err;

