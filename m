Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaLDJBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:01:08 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:44578 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752853AbaLDJBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:01:06 -0500
Message-ID: <548022B3.8050105@arm.com>
Date: Thu, 04 Dec 2014 09:00:35 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH 2/5] ASoC: dwc: Don't allow negative use counts
References: <547F3C9F.8080102@arm.com> <20141203172526.GC7712@sirena.org.uk>
In-Reply-To: <20141203172526.GC7712@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/14 17:25, Mark Brown wrote:
> On Wed, Dec 03, 2014 at 04:38:55PM +0000, Andrew Jackson wrote:
> 
>>  	case SNDRV_PCM_TRIGGER_STOP:
>>  	case SNDRV_PCM_TRIGGER_SUSPEND:
>>  	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
>> -		dev->active--;
>> +		if (dev->active > 0)
>> +			dev->active--;
> 
> How is this triggering - this sounds like you're papering over some
> other bug somewhere?
> 

When I looked at the code paths I couldn't convince myself that STOP wouldn't be called more than once.  Then actuve would be negative and the device might not be restartable.  I didn't have a problem per se, it was just that it seemed to be something of a loophole.

   Andrew

