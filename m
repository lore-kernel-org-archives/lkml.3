Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbaCNJU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 05:20:59 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:44012 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577AbaCNJUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 05:20:55 -0400
MIME-Version: 1.0
In-Reply-To: <1394634313.28839.57.camel@joe-AO722>
References: <1394614210-15698-1-git-send-email-maxime.coquelin@st.com>
	<1394614210-15698-5-git-send-email-maxime.coquelin@st.com>
	<1394634313.28839.57.camel@joe-AO722>
Date: Fri, 14 Mar 2014 10:20:55 +0100
Message-ID: <CACRpkda0Z15zC=d8xe+KyHqgmTCHbnUjL14fBmtscpR-2kHtFQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/6] pinctrl: st: Use ARRAY_SIZE instead of raw value
 for number of delays
From: Linus Walleij <linus.walleij@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: Maxime COQUELIN <maxime.coquelin@st.com>, Rob Landley <rob@landley.net>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 3:25 PM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2014-03-12 at 09:50 +0100, Maxime COQUELIN wrote:
>> This patch replaces the raw values with ARRAY_SIZE for assigning the
>> ninput_delays and noutput_delays fields of STiH416's st_pctl_data struct.
>
> trivial note:
>
>> diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
> []
>> @@ -384,9 +384,9 @@ static unsigned int stih416_delays[] = {0, 300, 500, 750, 1000, 1250, 1500,
>>  static const struct st_pctl_data  stih416_data = {
>>       .rt_style       = st_retime_style_dedicated,
>>       .input_delays   = stih416_delays,
>> -     .ninput_delays  = 14,
>> +     .ninput_delays  = ARRAY_SIZE(stih416_delays),
>>       .output_delays  = stih416_delays,
>> -     .noutput_delays = 14,
>> +     .noutput_delays = ARRAY_SIZE(stih416_delays),
>>       .alt = 0, .oe = 40, .pu = 50, .od = 60, .rt = 100,
>>  };
>>
>
> drivers/pinctrl/pinctrl-st.c-   unsigned int    *input_delays;
> drivers/pinctrl/pinctrl-st.c-   unsigned int    *output_delays;
>
> It may be better to change these to const unsigned int *
> and change
>
> static unsigned int stih416_delays[] = {
>
> to static const

Good point. Patches accepted :-)

Yours,
Linus Walleij
