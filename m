Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaDDHeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 03:34:31 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19695 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaDDHe3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 03:34:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 04 Apr 2014 00:29:54 -0700
From: Arun Shamanna Lakshmi <aruns@nvidia.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Songhee Baek <sbaek@nvidia.com>
Date: Fri, 4 Apr 2014 00:34:28 -0700
Subject: RE: [PATCH] ASoC: dapm: Add support for multi register mux
Thread-Topic: [PATCH] ASoC: dapm: Add support for multi register mux
Thread-Index: Ac9P18chAi4cIc6ASHy33EUmQkB/2wAAE+WA
Message-ID: <781A12BB53C15A4BB37291FDE08C03F3A05CDCE1AA@HQMAIL02.nvidia.com>
References: <1396494710-20944-1-git-send-email-aruns@nvidia.com>
 <533D1B65.3030405@metafoo.de>
 <781A12BB53C15A4BB37291FDE08C03F3A05CDCDF9F@HQMAIL02.nvidia.com>
 <533E5FD4.8040403@metafoo.de>
In-Reply-To: <533E5FD4.8040403@metafoo.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Lars-Peter Clausen [mailto:lars@metafoo.de]
> Sent: Friday, April 04, 2014 12:32 AM
> To: Arun Shamanna Lakshmi
> Cc: lgirdwood@gmail.com; broonie@kernel.org;
> swarren@wwwdotorg.org; perex@perex.cz; tiwai@suse.de; alsa-
> devel@alsa-project.org; linux-kernel@vger.kernel.org; Songhee Baek
> Subject: Re: [PATCH] ASoC: dapm: Add support for multi register mux
> 
> On 04/03/2014 10:11 PM, Arun Shamanna Lakshmi wrote:
> [...]
> >> Here as well, default for bit_pos should be 0.
> >
> > This means when 'None' of the options are selected, by default, it
> > enumerates to 0. Since we are using __ffs, BIT(0) of Register-0 also
> > enumerates to 0. That's the reason why I used just ffs in the first place.
> > Let me know your opinion. My value table looks like below.
> >
> > #define MUX_VALUE(npart, nbit)	(nbit + 32 * npart)
> > static const int mux_values[] = {
> > 	0,
> > 	MUX_VALUE(0, 0),
> > 	.
> > 	.
> > 	.
> > 	MUX_VALUE(0, 31),
> > 	/* above inputs are for part0 mux */
> > 	MUX_VALUE(1, 0),
> > 	.
> > 	.
> > 	.
> > 	MUX_VALUE(1, 31),
> > 	/* above inputs are for part1 mux */
> > 	MUX_VALUE(2, 0),
> > 	.
> > 	.
> > 	.
> > 	MUX_VALUE(2, 31),
> > 	/* above inputs are for part2 mux */
> > };
> 
> Ok, so having none of the input selected should be a valid user selectable
> option?

Yes. If 'None' is selected, it goes and clears the register. So, can we have ffs( )
instead of __ffs( ) ? It would fix this case.

- Arun
