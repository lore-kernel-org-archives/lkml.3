Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965694Ab3DREMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 00:12:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:1398 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965613Ab3DREL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 00:11:59 -0400
X-IronPort-AV: E=Sophos;i="4.87,498,1363104000"; 
   d="scan'208";a="7083785"
Message-ID: <516F7312.3050002@cn.fujitsu.com>
Date: Thu, 18 Apr 2013 12:14:10 +0800
From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
CC: yongjun_wei@trendmicro.com.cn, Wei Yongjun <weiyj.lk@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] ALSA: hda - fix error return code in patch_alc662()
References: <516F71F3.7090805@cn.fujitsu.com>
In-Reply-To: <516F71F3.7090805@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/18 12:08:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/18 12:08:24,
	Serialize complete at 2013/04/18 12:08:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, i miss something..

Thanks,
wang

> Hello Wei,
> 
> +++ b/sound/pci/hda/patch_realtek.c
> @@ -3787,7 +3787,8 @@ static int patch_alc662(struct hda_codec *codec)
>  	if ((alc_get_coef0(codec) & (1 << 14)) &&
>  	    codec->bus->pci->subsystem_vendor == 0x1025 &&
>  	    spec->cdefine.platform_type == 1) {
> -		if (alc_codec_rename(codec, "ALC272X") < 0)
> 
> I don't think we should fix this problem. And your changelog is wrong!
> 
> Thanks,
> Wang
> +		err = alc_codec_rename(codec, "ALC272X");
> +		if (err < 0)
>  			goto error;
>  	}
>  
> 
> --
> 



