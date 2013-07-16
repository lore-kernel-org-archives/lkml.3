Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab3GPJG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:06:28 -0400
Received: from smtp-out-221.synserver.de ([212.40.185.221]:1114 "EHLO
	smtp-out-221.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab3GPJG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:06:26 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 15748
Message-ID: <51E50D3B.2050207@metafoo.de>
Date: Tue, 16 Jul 2013 11:07:07 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Vinod Koul <vinod.koul@intel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/2] ASoC: dmaengine-pcm: Add support for querying DMA capabilities
References: <1373906531-6938-1-git-send-email-lars@metafoo.de> <20130715172643.GZ11538@sirena.org.uk> <20130715165721.GV16653@intel.com> <20130715175726.GA11538@sirena.org.uk> <51E43D6C.1050000@metafoo.de> <20130715195145.GB11538@sirena.org.uk>
In-Reply-To: <20130715195145.GB11538@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 09:51 PM, Mark Brown wrote:
> On Mon, Jul 15, 2013 at 08:20:28PM +0200, Lars-Peter Clausen wrote:
>> On 07/15/2013 07:57 PM, Mark Brown wrote:
>>> On Mon, Jul 15, 2013 at 10:27:21PM +0530, Vinod Koul wrote:
> 
>>> Right, we probably want to set an artificial floor here but it still
>>> seems like we should be checking that the device actually supports this.
>>> If the hardware can only support 64 bytes then the above code won't work
>>> properly.
> 
>> It shouldn't be to hard to extend the dma_caps API with a
>> min_sg_len. But is this something you've actually seen in existing
>> hardware for that the driver would make use of the dmaengine PCM
>> framework? If it is more of theoretical nature we can still easily
>> add it later if it becomes necessary.
> 
> I'm not aware of anything but equally well I made zero effort to look
> and note that quite a few existing drivers appear to have minimum values
> quite a bit above 16 though I doubt they are all actual restrictions.

I would assume that most of them don't express hardware limitations but
rather are sensible lower limits which allow operation without
over-/underruns. But that's something that doesn't necessarily depend on the
DMA controller, but rather on the system as a whole, e.g. on a slower
machine you'd typically set the limit higher so the CPU has a better chance
to keep up. So this isn't something you'd want to set in the DMA controller
driver. But I'm not sure if there is a good way to calculate a sensible
minimum buffer size based on the whole system's constraints.

- Lars

