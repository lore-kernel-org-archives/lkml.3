Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509AbaGPLQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 07:16:56 -0400
Received: from service87.mimecast.com ([91.220.42.44]:43101 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757199AbaGPLQz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 07:16:55 -0400
Message-ID: <53C65F22.20101@arm.com>
Date: Wed, 16 Jul 2014 12:16:50 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
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
References: <1405071167-14503-1-git-send-email-jaswinder.singh@linaro.org> <1405071325-14683-1-git-send-email-jaswinder.singh@linaro.org> <53C64883.2050709@arm.com> <5340858.B9CZUE8s0j@wuerfel>
In-Reply-To: <5340858.B9CZUE8s0j@wuerfel>
X-OriginalArrivalTime: 16 Jul 2014 11:16:49.0532 (UTC) FILETIME=[701493C0:01CFA0E7]
X-MC-Unique: 114071612165200601
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 16/07/14 11:16, Arnd Bergmann wrote:
> On Wednesday 16 July 2014 10:40:19 Sudeep Holla wrote:
>>> +
>>> +Required property:
>>> +- mbox: List of phandle and mailbox channel specifier.
>>> +
>>> +- mbox-names: List of identifier strings for each mailbox channel
>>> +               required by the client.
>>> +
>>
>> IMO the mailbox names are more associated with the controller channels/
>> mailbox rather than the clients using it. Does it make sense to move
>> this under controller. It also avoid each client replicating the names.
>
> I think it would be best to just make the mbox-names property optional,
> like we have for other subsystems.
>

OK that makes sense.

> Doing it in the mbox-controller makes no sense at all, because the
> mbox controller has (or should have) no idea what the attached devices are.
>

Agreed if these mbox-names are more specific to attached devices and that
was my initial understanding too. But I got confused when I saw something
like below in the patch[1]

+       mhu: mhu0@2b1f0000 {
+               #mbox-cells = <1>;
+               compatible = "fujitsu,mhu";
+               reg = <0 0x2B1F0000 0x1000>;
+               interrupts = <0 36 4>, /* LP Non-Sec */
+                            <0 35 4>, /* HP Non-Sec */
+                            <0 37 4>; /* Secure */
+       };
+
+       mhu_client: scb@0 {
+               compatible = "fujitsu,scb";
+               mbox = <&mhu 1>;
+               mbox-names = "HP_NonSec";
+       };

Here the name used is more controller specific.

Regards,
Sudeep

[1] http://www.spinics.net/lists/arm-kernel/msg346991.html

