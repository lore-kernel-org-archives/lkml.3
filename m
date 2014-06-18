Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbaFRQsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:48:32 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:38013 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaFRQsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:48:30 -0400
Date: Wed, 18 Jun 2014 17:48:22 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: Kevin Hilman <khilman@linaro.org>, Bjorn Andersson <bjorn@kryo.se>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH v3 0/3] Qualcomm Resource Power Manager driver
Message-ID: <20140618164822.GC25353@lee--X1>
References: <1402944372-31901-1-git-send-email-bjorn.andersson@sonymobile.com>
 <7hvbrzbh1u.fsf@paris.lan>
 <CAJAp7OhHr4Cgcp9pvQ3=MAie_zSnFJxG28Vf37qJ98BK7P1jaQ@mail.gmail.com>
 <7hzjha8b97.fsf@paris.lan>
 <842A7147-A2CC-42BD-9947-CBADF738DC92@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <842A7147-A2CC-42BD-9947-CBADF738DC92@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Kumar Gala wrote:

> 
> On Jun 18, 2014, at 10:53 AM, Kevin Hilman <khilman@linaro.org> wrote:
> 
> > Bjorn Andersson <bjorn@kryo.se> writes:
> > 
> >> On Tue, Jun 17, 2014 at 10:07 AM, Kevin Hilman <khilman@linaro.org> wrote:
> >>> +Paul Walmsley
> >>> 
> >>> Bjorn Andersson <bjorn.andersson@sonymobile.com> writes:
> >>> 
> >>>> This series adds a regulator driver for the Resource Power Manager found in
> >>>> Qualcomm 8660, 8960 and 8064 based devices.
> >>>> 
> >>>> The RPM driver exposes resources to its child devices, that can be accessed to
> >>>> implement drivers for the regulators, clocks and bus frequency control that's
> >>>> owned by the RPM in these devices.
> >>>> 
> >>>> Changes since v2:
> >>>>  - Fix copy-paste error in dt binding
> >>>>  - Correct incomplete move from mfd to soc
> >>>>  - Correct const mistake in regulator driver
> >>>> 
> >>>> Changes since v1:
> >>>>  - Moved rpm driver to drivers/soc
> >>> 
> >>> I'm not sure I follow the motivation for having this under drivers/soc?
> >>> 
> >> Hi Kevin,
> >> 
> >> I've made the argument that to me this is conceptually a black box
> >> handling regulators, clocks and other stuff; hence similar to a PMIC,
> >> which would fit nicely into drivers/mfd.
> >> 
> >> I still think this is the case and now that I look back I didn't get
> >> any pushback from Lee Jones so maybe the move was premature?
> > 
> > Yes, IMO, the move was premature, but hopefully the drivers/soc folks
> > can chime in an clarify the criteria for inclusion there.
> > 
> > Kevin
> 
> I dont agree, I think having this in drivers/soc means that we can
> clearly go through drivers/soc in the future and look for patterns
> across SoCs that should be re-factored.

> Where MFD seems like its become the new drivers misc.

Do you have any grounds for that statement?  I only know of one driver
which doesn't fit the bounds of a true MFD.  If you know of more, I'd
like to hear about it.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
