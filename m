Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab3FYPWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:22:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38670 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab3FYPWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:22:06 -0400
Message-ID: <51C9B59A.6000407@wwwdotorg.org>
Date: Tue, 25 Jun 2013 09:22:02 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Christian Ruppert <christian.ruppert@abilis.com>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 2/2] Make non-linear GPIO ranges accesible from gpiolib
References: <CACRpkdY9F0cUaRfGJnHJW=2dYf_yKkr3M8Kh+_e6XQhh1WBoUA@mail.gmail.com> <1371128132-18266-2-git-send-email-christian.ruppert@abilis.com> <51BA3BC1.3090109@wwwdotorg.org> <20130614091241.GA23745@ab42.lan> <51C1F42E.5090107@wwwdotorg.org> <51C1F82C.4020502@wwwdotorg.org> <20130620115710.GB942@ab42.lan> <51C4C2ED.5090505@wwwdotorg.org> <CACRpkdaPJaZb7z+ua91MJ_krDRXGSaZS_5_3vHc7VcAFjUfdfQ@mail.gmail.com>
In-Reply-To: <CACRpkdaPJaZb7z+ua91MJ_krDRXGSaZS_5_3vHc7VcAFjUfdfQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 08:32 AM, Linus Walleij wrote:
> On Fri, Jun 21, 2013 at 11:17 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 06/20/2013 05:57 AM, Christian Ruppert wrote:
> 
>> The Linux pinctrl subsystem specifically doesn't provide mutual
>> exclusion between "mux function" and GPIO usage within a pin group,
>> although perhaps a driver could internally.
> 
> It used to block this at one point. But it doesn't make sense
> when the hardware looks like so:
> 
>>>                                                      +- SPI
>>>                  Physical pins --- GPIO --- pinctrl -+- I2C
>>>                                                      +- mmc
> 
> As in this case it is perfectly legal to enable the GPIO as
> input while the I2C bus is running and "spy" on the signals.
> 
> The driver should probably not allow the GPIO output to be
> driven while some peripheral is muxed in though, that could be
> disastrous...

Well, in the HW diagram above, GPIO output probably simply overrides
"mux function" output, so everything would work as requested. Whether it
makes sense to request such an override is a policy question that
pinctrl itself probably shouldn't decide. After all, what if there's a
pin group containing 4 pins, which are used by the board as 2 GPIO and 2
I2C. pinctrl shouldn't disallow selecting GPIO on any pin in that pin
group simply because I2C is selected on it; that fact doesn't
necessarily mean that the selected mux function actually uses every
single pin in the group.
