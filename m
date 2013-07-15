Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab3GOSUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:20:33 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:59644 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753156Ab3GOSUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:20:31 -0400
Message-ID: <51E43D6C.1050000@metafoo.de>
Date: Mon, 15 Jul 2013 20:20:28 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Vinod Koul <vinod.koul@intel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/2] ASoC: dmaengine-pcm: Add support for querying DMA capabilities
References: <1373906531-6938-1-git-send-email-lars@metafoo.de> <20130715172643.GZ11538@sirena.org.uk> <20130715165721.GV16653@intel.com> <20130715175726.GA11538@sirena.org.uk>
In-Reply-To: <20130715175726.GA11538@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 07:57 PM, Mark Brown wrote:
> On Mon, Jul 15, 2013 at 10:27:21PM +0530, Vinod Koul wrote:
>> On Mon, Jul 15, 2013 at 06:26:43PM +0100, Mark Brown wrote:
>>> On Mon, Jul 15, 2013 at 06:42:10PM +0200, Lars-Peter Clausen wrote:
>
>>>> +	hw.period_bytes_min = 16;
>>>> +	hw.period_bytes_max = dma_caps.max_sg_len;
>
>>> We can't read the minimum period size from dmaengine? Seems like
>>> something might have a restriction other than 16 bytes here.
>
>> max would be how many list items the engine supports so queried therotical min
>> would be 1 byte, not sure how 16 bytes is assumed above but my guess is that if
>> engine is able to push min burst lengths which would be 1 and give you
>> interrupt. But seriously, that would not be practical. So this should be a
>> realistic limit which system can cope with.
>
> Right, we probably want to set an artificial floor here but it still
> seems like we should be checking that the device actually supports this.
> If the hardware can only support 64 bytes then the above code won't work
> properly.
>

It shouldn't be to hard to extend the dma_caps API with a min_sg_len. But is 
this something you've actually seen in existing hardware for that the driver 
would make use of the dmaengine PCM framework? If it is more of theoretical 
nature we can still easily add it later if it becomes necessary.

That said it is not uncommon that the segment size needs to be a multiple of 
the burst size. Adding support for that is still on my TODO list but will 
require some changes to some of the existing users, since implementing this 
will be a lot easier if all users use the snd_dmaengine_dai_dma_data struct for 
their DAI DMA data.

- Lars
