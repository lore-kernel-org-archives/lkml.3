Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaLDJI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:08:26 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:44122 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751147AbaLDJIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:08:23 -0500
Message-ID: <54802467.4000702@arm.com>
Date: Thu, 04 Dec 2014 09:07:51 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: rajeev kumar <rajeevkumar.linux@gmail.com>,
        Mark Brown <broonie@kernel.org>
CC: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH 2/5] ASoC: dwc: Don't allow negative use counts
References: <547F3C9F.8080102@arm.com>	<20141203172526.GC7712@sirena.org.uk>	<CAA7nrtjrQ5SpDrZRPb58zqmZrWahY3XOMWnmdH70WLr3q46_bA@mail.gmail.com> <CAA7nrth+h32Un2C4z106wL181eru7hwFDxMdS00X55h5Zw=-Vg@mail.gmail.com>
In-Reply-To: <CAA7nrth+h32Un2C4z106wL181eru7hwFDxMdS00X55h5Zw=-Vg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/14 06:43, rajeev kumar wrote:
> On Thu, Dec 4, 2014 at 12:10 PM, rajeev kumar
> <rajeevkumar.linux@gmail.com> wrote:
>> On Wed, Dec 3, 2014 at 10:55 PM, Mark Brown <broonie@kernel.org> wrote:
>>> On Wed, Dec 03, 2014 at 04:38:55PM +0000, Andrew Jackson wrote:
>>>
>>>>       case SNDRV_PCM_TRIGGER_STOP:
>>>>       case SNDRV_PCM_TRIGGER_SUSPEND:
>>>>       case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
>>>> -             dev->active--;
>>>> +             if (dev->active > 0)
>>>> +                     dev->active--;
>>>
>>> How is this triggering - this sounds like you're papering over some
>>> other bug somewhere?
> 
> This check can be removed as it is not going to triggered.

As I said in my email to Mark, I couldn't convince myself that STOP/SUSPEND would only be called once so it seemed like a loophole which /might/ result in the device not functioning correctly.

If this can never happen, I'll drop the patch.

	Andrew

> B'rgds
> ~Rajeev
> 

