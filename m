Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935657Ab3IEKLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 06:11:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:8212 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935588Ab3IEKLP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 06:11:15 -0400
X-IronPort-AV: E=Sophos;i="4.90,846,1371052800"; 
   d="scan'208";a="8422768"
Message-ID: <5228589C.2060508@cn.fujitsu.com>
Date: Thu, 05 Sep 2013 18:10:36 +0800
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: perex@perex.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALSA: emu10k1: casting (void *) value returned by kcalloc
 is useless
References: <52281D37.40808@cn.fujitsu.com> <1378361546.1944.8.camel@joe-AO722>
In-Reply-To: <1378361546.1944.8.camel@joe-AO722>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/05 18:09:03,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/05 18:09:03
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年09月05日 14:12, Joe Perches 写道:
> On Thu, 2013-09-05 at 13:57 +0800, Duan Jiong wrote:
>> From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
>>
>> Casting (void *) value returned by kcalloc is useless
>> as mentioned in Documentation/CodingStyle, Chap 14.
> 
> __user is an important marker that is lost here.
> 
>> diff --git a/sound/pci/emu10k1/emufx.c b/sound/pci/emu10k1/emufx.c
> []
>> @@ -1183,9 +1183,8 @@ static int _snd_emu10k1_audigy_init_efx(struct snd_emu10k1 *emu)
>>  	mm_segment_t seg;
>>  
>>  	if ((icode = kzalloc(sizeof(*icode), GFP_KERNEL)) == NULL ||
>> -	    (icode->gpr_map = (u_int32_t __user *)
>> -	     kcalloc(512 + 256 + 256 + 2 * 1024, sizeof(u_int32_t),
>> -		     GFP_KERNEL)) == NULL ||
>> +	    (icode->gpr_map = kcalloc(512 + 256 + 256 + 2 * 1024,
>> +				sizeof(u_int32_t), GFP_KERNEL)) == NULL ||
>>  	    (controls = kcalloc(SND_EMU10K1_GPR_CONTROLS,
>>  				sizeof(*controls), GFP_KERNEL)) == NULL) {
>>  		err = -ENOMEM;
> 
> I think this would be clearer as
> 
> 	err = -ENOMEM;
> 	icode = kzalloc(sizeof(*icode), GFP_KERNEL)
> 	if (!icode)
> 		goto err;
> 	icode->gpr_map = (__user)kcalloc(512 + 256 + 256 + 2 * 1024,
> 					 sizeof(u_int32_t), GFP_KERNEL);
> 	if (!icode->gpr_map)
> 		goto err;
> 	controls = kcalloc(SND_EMU10K1_GPR_CONTROLS,
> 			    sizeof(*controls), GFP_KERNEL);
> 	if (!controls)
> 		goto err;
> 

Maybe it should keep the original style, because i do as you said, and
error messages appear during compiling the kernel.

Thanks,
  Duan

