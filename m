Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaHBHrV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 03:47:21 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:52223 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaHBHrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 03:47:19 -0400
MIME-Version: 1.0
In-Reply-To: <20140801184314.GM30458@sirena.org.uk>
References: <1406896194-4667-1-git-send-email-jaswinder.singh@linaro.org>
	<1406896365-4971-1-git-send-email-jaswinder.singh@linaro.org>
	<20140801184314.GM30458@sirena.org.uk>
Date: Sat, 2 Aug 2014 13:17:18 +0530
Message-ID: <CAJe_ZhdNjH+eyxMfpAw8Zg1SeZa1qh2ouMnTSress+6Gyr+5qA@mail.gmail.com>
Subject: Re: [PATCHv10 4/4] dt: mailbox: add generic bindings
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Devicetree List <devicetree@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Matt Porter <mporter@linaro.org>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Loic Pallardy <loic.pallardy@st.com>, "Anna, Suman" <s-anna@ti.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        Bjorn Andersson <bjorn@kryo.se>, Patch Tracking <patches@linaro.org>,
        Mollie Wu <mollie.wu@linaro.org>,
        Tetsuya Takinishi <t.takinishi@jp.fujitsu.com>,
        Kevin Hilman <khilman@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Andy Green <andy.green@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 August 2014 00:13, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Aug 01, 2014 at 06:02:45PM +0530, Jassi Brar wrote:
>
>> +Optional property:
>> +- mbox-names: List of identifier strings for each mailbox channel
>> +             required by the client. The use of this property
>> +             is discouraged in favor of using index in list of
>> +             'mboxes' while requesting a mailbox.
>
> Can I suggest that if we do want to avoid strings for some reason (it's
> not obvious to me why)
>
The string and index are both to be taken from DT node of client.

    pwr_cntrl: power {
               ...
               mbox-names = "pwr-ctrl", "rpc";
               mboxes = <&mailbox 0
                       &mailbox 1>;
    };

The xlate() will map string onto index. So rather than the client
driver specify, say, "rpc" while requesting mailbox channel, it can
directly specify index 1.

> then we include a recommendation to provide
> defines in a header file in order to improve legibility.  That's pretty
> minor, though.
>
Sorry I don't understand.

> Reviewed-by: Mark Brown <broonie@linaro.org>
>
Thanks a lot!
-Jassi
