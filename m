Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbaLVOJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 09:09:24 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:47066 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754524AbaLVOJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 09:09:23 -0500
Message-ID: <549825EC.80505@arm.com>
Date: Mon, 22 Dec 2014 14:08:44 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/5] ASoC: dwc: Iterate over all channels
References: <cover.1418826016.git.Andrew.Jackson@arm.com> <67cea1f0a74c333ec2048c7796cda37302d45e95.1418826016.git.Andrew.Jackson@arm.com> <20141222135301.GQ17800@sirena.org.uk>
In-Reply-To: <20141222135301.GQ17800@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/14 13:53, Mark Brown wrote:
> On Fri, Dec 19, 2014 at 04:18:06PM +0000, Andrew Jackson wrote:
> 
>> The Designware core can be configured with up to four stereo channels.
>> Each stereo channel is individually configured so, when the driver's
>> hw_params call is made, each requested stereo channel has to be
>> programmed.
> 
> This is quite unclear to someone who doesn't know the hardware, is this
> a bug fix or a new feature?  It looks like it's a fix...
> 

It is a fix.  In the Designware core, each stereo channel is configured
individually.  So, when hw_params is called to configure N channels, 
N/2 stereo channels need to be configured in the core.  The existing
code doesn't do this and will only configure the highest numbered 
channel.

    Andrew

