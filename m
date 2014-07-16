Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934034AbaGPN37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:29:59 -0400
Received: from service87.mimecast.com ([91.220.42.44]:40545 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622AbaGPN35 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:29:57 -0400
Message-ID: <53C67E54.2010104@arm.com>
Date: Wed, 16 Jul 2014 14:29:56 +0100
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
References: <1405071167-14503-1-git-send-email-jaswinder.singh@linaro.org> <5340858.B9CZUE8s0j@wuerfel> <53C65F22.20101@arm.com> <5773443.uubaG3Evxs@wuerfel>
In-Reply-To: <5773443.uubaG3Evxs@wuerfel>
X-OriginalArrivalTime: 16 Jul 2014 13:29:54.0473 (UTC) FILETIME=[0779E190:01CFA0FA]
X-MC-Unique: 114071614295504701
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 16/07/14 12:32, Arnd Bergmann wrote:
> On Wednesday 16 July 2014 12:16:50 Sudeep Holla wrote:
>>
>> Agreed if these mbox-names are more specific to attached devices and that
>> was my initial understanding too. But I got confused when I saw something
>> like below in the patch[1]
>>
>> +       mhu: mhu0@2b1f0000 {
>> +               #mbox-cells = <1>;
>> +               compatible = "fujitsu,mhu";
>> +               reg = <0 0x2B1F0000 0x1000>;
>> +               interrupts = <0 36 4>, /* LP Non-Sec */
>> +                            <0 35 4>, /* HP Non-Sec */
>> +                            <0 37 4>; /* Secure */
>> +       };
>> +
>> +       mhu_client: scb@0 {
>> +               compatible = "fujitsu,scb";
>> +               mbox = <&mhu 1>;
>> +               mbox-names = "HP_NonSec";
>> +       };
>>
>> Here the name used is more controller specific.
>
> The name is definitely specific to the client, not the master. The

IIUC this controller has 3 channels: Secure, High and Low Priority Non 
Secure.
I assumed the name is derived from that rather than what the client is
using it for, hence the confusion. That might be fine but I am more 
interested
what will be the name if another client uses the same channel in the above
example.

Regards,
Sudeep

> string "HP_NonSec" should be required in the binding for the "fujitsu,scb"
> device here, and the scb driver should pass that hardcoded string
> to the mailbox API to ask for a channel.
>
> 	Arnd
>
>

