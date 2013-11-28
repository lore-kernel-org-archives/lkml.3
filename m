Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab3K1IaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 03:30:00 -0500
Received: from 2.mo6.mail-out.ovh.net ([46.105.76.65]:60014 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753193Ab3K1I34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 03:29:56 -0500
Message-ID: <5296FEEB.7070205@overkiz.com>
Date: Thu, 28 Nov 2013 09:29:31 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: colin@horizon.com
CC: devicetree@vger.kernel.org, linux@horizon.com,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH v2 0/2] clk: add clk accuracy support
References: <20131127231125.7995.qmail@science.horizon.com>
In-Reply-To: <20131127231125.7995.qmail@science.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 18372434680212584460
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -110
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfghrlhcuvffnffculddquddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -110
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfghrlhcuvffnffculddquddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 28/11/2013 00:11, colin@horizon.com wrote:
> Um, do you have a definition somewhere (like in comments) of the definition
> of the accuracy you're using?  So multiple people can add consistent values?
>
> Is this the standard deviation (67% confidence), 2 standard deviations
> (95%), 3 (99%), or something else?
>
> What averaging time is this computed over?  Usually clock stability (which
> I recognize is not accuracy) is expressed using the Allan deviation,
>
> http://tf.nist.gov/general/glossary.htm#allandeviation
>
> This is because real clocks have unbounded asymptotic error.  Over long
> time intervals, have a random frequency walk characteristic, where the
> frequency error after time T is proportional to sqrt(T).
>
> So an oscillator which is stable to 1ppb over a T second interval will be
> stable to 2ppb over a 4T second interval, 3ppb over a 9T second interval,
> and so on.
>
> Since accuracy is limited by stability, and there's no upper bound on
> instability, there's actually no upper bound on inaccuracy, either.
>
> (Admittedly, your typical crystal oscillators have their stability
> limited by environmental instability, particularly temperature, which
> dwarfs the frequency flicker noise limit.)
>
>
> On the flip side, some systems are synchronized to UTC by various means.
> This means (if we either neglect UTC's far sub-ppb instability, or just
> define it as "perfect") that the inaccuracy over a long enough averaging
> interval is zero.
>
> But if it only synchronizes once a day, there can be significant
> inaccuracy between synchronization.  Should the accuracy specification
> reflect that shorter-term instability?
>
>
> Finally, you can't specify *too* short an interval, because clocks also
> have increasing error over small time intervals.  Below 10 seconds or
> so, white noise cycle-to-cycle jitter dominates, and the fewer cycles
> you average over, the larger it appears to be.
>
>
> A clear definition would help people understand what numbers to put in.

Thanks for these informations, it helped me understand the different sources
of inaccuracies of a crystal.
As I said earlier, I'm not an expert in this area, and all your comments and
feedbacks are welcome.
BTW does this apply to other clk generators (RC oscillators, PLLs, ...), 
or is this only
applicable to crystal oscillators ?

Regarding the exact definition of accuracy, I guess in case of crystals 
this has more
to do with stability.

I found something called "Total stability" in several datasheet
(e.g. http://www.silabs.com/Support%20Documents/TechnicalDocs/si510-11.pdf).
Is this something applicable to our case ?

Keep in mind that the primary goal of the clk accuracy retrieval is to 
give a clock
user a way to choose the most accurate clock among several available clocks.
This means we don't need the value to be extremely precise, but at least 
(as you
stated) these values should represent the same things.

Best Regards,

Boris
