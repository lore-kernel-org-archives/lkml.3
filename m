Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246AbaGPLdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 07:33:36 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:52997 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134AbaGPLde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 07:33:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: Jassi Brar <jaswinder.singh@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "courtney.cavin@sonymobile.com" <courtney.cavin@sonymobile.com>,
        "mporter@linaro.org" <mporter@linaro.org>,
        "slapdau@yahoo.com.au" <slapdau@yahoo.com.au>,
        "lftan.linux@gmail.com" <lftan.linux@gmail.com>,
        "loic.pallardy@st.com" <loic.pallardy@st.com>,
        "s-anna@ti.com" <s-anna@ti.com>,
        "ashwin.chaugule@linaro.org" <ashwin.chaugule@linaro.org>,
        "bjorn@kryo.se" <bjorn@kryo.se>,
        "patches@linaro.org" <patches@linaro.org>,
        "Mollie.Wu@tw.fujitsu.com" <Mollie.Wu@tw.fujitsu.com>,
        "t.takinishi@jp.fujitsu.com" <t.takinishi@jp.fujitsu.com>
Subject: Re: [PATCHv8 2/2] mailbox: Introduce framework for mailbox
Date: Wed, 16 Jul 2014 13:32:44 +0200
Message-ID: <5773443.uubaG3Evxs@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53C65F22.20101@arm.com>
References: <1405071167-14503-1-git-send-email-jaswinder.singh@linaro.org> <5340858.B9CZUE8s0j@wuerfel> <53C65F22.20101@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:nS1N/0UaSQ0Ffm6ixRbrP3p+VDxl4KchhEsUBTW2Lub
 yqeyKwo/T8TokoSqgoHqjSvTi+yLKsrKa/kUcD5WsxT7JssoOu
 GFs66Sduf38/KSt1pmARbnHshyy0WyIkUMm193C8Qxyrdk/NJl
 jx2b/YTOgM9Ft9YmGbO59f6QN9oUdBDpqpzReCN5UAlccfV+LR
 g3Aa+u9kEA9cHxs/8PgIFSlLd4ULHOQhbB/XwvIh6mFKaz+9OM
 KQh/rGuoyUunqMpLMW9dRFoDTk6FdDmJECNcmMEO7yjw1IDtWY
 4XsJp8qF9pjgkQLsegVsNgH76hTHk0k03V2ezlcrlKssi58g8o
 jhUCVktPkfYPhEC6VTDs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 July 2014 12:16:50 Sudeep Holla wrote:
> 
> Agreed if these mbox-names are more specific to attached devices and that
> was my initial understanding too. But I got confused when I saw something
> like below in the patch[1]
> 
> +       mhu: mhu0@2b1f0000 {
> +               #mbox-cells = <1>;
> +               compatible = "fujitsu,mhu";
> +               reg = <0 0x2B1F0000 0x1000>;
> +               interrupts = <0 36 4>, /* LP Non-Sec */
> +                            <0 35 4>, /* HP Non-Sec */
> +                            <0 37 4>; /* Secure */
> +       };
> +
> +       mhu_client: scb@0 {
> +               compatible = "fujitsu,scb";
> +               mbox = <&mhu 1>;
> +               mbox-names = "HP_NonSec";
> +       };
> 
> Here the name used is more controller specific.

The name is definitely specific to the client, not the master. The
string "HP_NonSec" should be required in the binding for the "fujitsu,scb"
device here, and the scb driver should pass that hardcoded string
to the mailbox API to ask for a channel.

	Arnd
