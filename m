Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaFWXUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 19:20:43 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:43287 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaFWXUk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 19:20:40 -0400
MIME-Version: 1.0
In-Reply-To: <53A8B306.1010903@suse.de>
References: <1403486483-4063-1-git-send-email-afaerber@suse.de>
	<1403486483-4063-2-git-send-email-afaerber@suse.de>
	<CAK5sBcGM6TLiMfhktGaeL9hvPFbAXN6mWFq=irWUVHnZi=BWNg@mail.gmail.com>
	<53A8B306.1010903@suse.de>
Date: Mon, 23 Jun 2014 16:20:39 -0700
X-Google-Sender-Auth: Pj2ccq1lYhh72O1vvbJaKk_ig9k
Message-ID: <CAD=FV=Wvu9WzTACovCjmOsce7KUStfAH7PX8rgROA0007HrahA@mail.gmail.com>
Subject: Re: [PATCH 1/4] Documentation: devicetree: Fix s2mps11 and s5m8767 typos
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: Sachin Kamat <sachin.kamat@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@linaro.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        "OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        DOCUMENTATION <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas,

On Mon, Jun 23, 2014 at 4:06 PM, Andreas Färber <afaerber@suse.de> wrote:
> I was wondering which character to type, and found two undocumented
> s5m8767_pmic properties downstream (s5m-core,enable-low-jitter and
> s5m-core,device_type = <0x2>), which I then left out.

I don't know much about "s5m-core,device_type", but I doubt it's
needed.  You can see <http://crosreview.com/42202> for details.  I
haven't looked but I'd bet that we just get this from the compatible
string now.

I did do a (very!) quick look and I see that low-jitter was originally
implemented in the local 3.4 kernel at <http://crosreview.com/43624>.
...and the local 3.8 kernel at <http://crosreview.com/66037>.

NOTE: it's pretty important to make sure low-jitter is turned on for
Chromebooks if you actually want full functionality.  At least on
exynos5250-snow (with the max77686 PMIC) you'd get occasional (and
very strange and very hard to debug) TPM errors if you didn't have
low-jitter.  The TPM is part of the security model on Chromebooks and
you might have a hard time accessing the encrypted parts of the disk
without it.


-Doug
