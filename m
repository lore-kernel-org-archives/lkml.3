Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab3H0JzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 05:55:10 -0400
Received: from mailout07.t-online.de ([194.25.134.83]:60234 "EHLO
	mailout07.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab3H0JzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 05:55:08 -0400
X-Greylist: delayed 1134 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Aug 2013 05:55:08 EDT
Message-ID: <521C72FF.5070902@t-online.de>
Date: Tue, 27 Aug 2013 11:35:59 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Hans Verkuil <hansverk@cisco.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [REGRESSION 3.11-rc] wm8775 9-001b: I2C: cannot write ??? to
 register R??
References: <521A269D.3020909@t-online.de> <521C5493.1050407@cisco.com>
In-Reply-To: <521C5493.1050407@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: ECB6CyZGZhkyZkxV+SLTpkBnQJNXHHS6OVGXcxeggks7n1+RjCudzL7s2AzIjuFZ52
X-TOI-MSGID: 60e98cad-2fe4-4da5-a2eb-cd49f04043ce
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.08.2013 09:26, Hans Verkuil wrote:
> On 08/25/2013 05:45 PM, Knut Petersen wrote:
>> Booting current git kernel dmesg shows a set of new  warnings:
>>
>>      "wm8775 9-001b: I2C: cannot write ??? to register R??"
>>
>> Nevertheless, the hardware seems to work fine.
>>
>> This is a new problem, introduced after kernel 3.10.
>> If necessary I can bisect.
> Can you try this patch? I'm pretty sure this will fix it.

Indeed, it does cure the problem. Thanks.

Tested-by: Knut Petersen <Knut_Petersen@t-online.de>


>
> Regards,
>
> 	Hans
>
> diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
> index afe0eae..28893a6 100644
> --- a/drivers/media/pci/cx88/cx88.h
> +++ b/drivers/media/pci/cx88/cx88.h
> @@ -259,7 +259,7 @@ struct cx88_input {
>   };
>   
>   enum cx88_audio_chip {
> -	CX88_AUDIO_WM8775,
> +	CX88_AUDIO_WM8775 = 1,
>   	CX88_AUDIO_TVAUDIO,
>   };
>   
>
>

