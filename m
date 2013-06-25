Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab3FYPjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:39:32 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60427 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab3FYPj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:39:26 -0400
Message-ID: <51C9B9AB.2010403@wwwdotorg.org>
Date: Tue, 25 Jun 2013 09:39:23 -0600
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
References: <CACRpkdY9F0cUaRfGJnHJW=2dYf_yKkr3M8Kh+_e6XQhh1WBoUA@mail.gmail.com> <1371128132-18266-2-git-send-email-christian.ruppert@abilis.com> <51BA3BC1.3090109@wwwdotorg.org> <20130614091241.GA23745@ab42.lan> <51C1F42E.5090107@wwwdotorg.org> <51C1F82C.4020502@wwwdotorg.org> <20130620115710.GB942@ab42.lan> <51C4C2ED.5090505@wwwdotorg.org> <CACRpkdZQ=G=K6g25gwGKfS1dCrDS35XepaOs38N-ymEuR0+x=g@mail.gmail.com>
In-Reply-To: <CACRpkdZQ=G=K6g25gwGKfS1dCrDS35XepaOs38N-ymEuR0+x=g@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 09:28 AM, Linus Walleij wrote:
> On Fri, Jun 21, 2013 at 11:17 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> 
>> And finally, I don't really like using pin groups for the purpose of
>> defining these mappings, since I intended them to purely represent the
>> mapping from register fields to the set of affected pins. However, I can
>> see an argument for doing this, since the pin groups are in fact still
>> representing /some/ aspect of the pinctrl internal HW.
> 
> The groups concept was part of the first pinctrl commit
> 2744e8afb3b76343e7eb8197e8b3e085036010a5
> and there the intention was clearly just to define a discrete
> set of pins.
> 
> And some drivers use it like this still, with no connection to
> physical registers, i.MX come to mind.
> 
> But I do seem to recall some endless discussions about this,
> I think we need to agree to disagree.

But the whole point of a subsystem is to provide clear common semantics
across all the different drivers that comprise it. IMHO, it's a great
failing of pinctrl that it doesn't clearly define its data model at all,
and just leaves individual driver authors to use groups in whatever
random fashion they want. We really should have different entries in the
pinctrl data model for these different concepts (real HW groups, and
logical/virtual/SW groups) since they're entirely different things with
different semantics.

Perhaps it's simplest if I just step out of pinctrl and let it exist as
it is.
