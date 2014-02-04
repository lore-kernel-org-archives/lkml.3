Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221AbaBDTCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:02:08 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:46490 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbaBDTCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:02:05 -0500
MIME-Version: 1.0
In-Reply-To: <1390145654.16433.102.camel@deadeye.wl.decadent.org.uk>
References: <7510122.cayuQ6qt8r@wuerfel> <1389999459-9483-1-git-send-email-matthew.garrett@nebula.com>
 <1390145654.16433.102.camel@deadeye.wl.decadent.org.uk>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue, 4 Feb 2014 11:01:23 -0800
Message-ID: <CAGVrzcbo7Ebvq1G7Gn+BJWsN622a5AiC6QkJKuhkpuX3yzUbHA@mail.gmail.com>
Subject: Re: [PATCH V3] net/dt: Add support for overriding phy configuration
 from device tree
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        netdev <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-01-19 Ben Hutchings <ben@decadent.org.uk>:
> On Fri, 2014-01-17 at 17:57 -0500, Matthew Garrett wrote:
>> Some hardware may be broken in interesting and board-specific ways, such
>> that various bits of functionality don't work. This patch provides a
>> mechanism for overriding mii registers during init based on the contents of
>> the device tree data, allowing board-specific fixups without having to
>> pollute generic code.
> [...]
>> --- a/Documentation/devicetree/bindings/net/phy.txt
>> +++ b/Documentation/devicetree/bindings/net/phy.txt
>> @@ -23,6 +23,21 @@ Optional Properties:
>>    assume clause 22. The compatible list may also contain other
>>    elements.
>>
>> +The following properties may be added to either the phy node or the parent
>> +ethernet device. If not present, the hardware defaults will be used.
>> +
>> +- phy-mii-advertise-10half: 1 to advertise half-duplex 10MBit, 0 to disable
>> +- phy-mii-advertise-10full: 1 to advertise full-duplex 10MBit, 0 to disable
>> +- phy-mii-advertise-100half: 1 to advertise half-duplex 100MBit, 0 to disable
>> +- phy-mii-advertise-100full: 1 to advertise full-duplex 100MBit, 0 to disable
>> +- phy-mii-advertise-100base4: 1 to advertise 100base4, 0 to disable
>> +- phy-mii-advertise-1000half: 1 to advertise half-duplex 1000MBit, 0 to disable
>> +- phy-mii-advertise-1000full: 1 to advertise full-duplex 1000MBit, 0 to disable
>
> Are these really all needed?  Apparently there is a standard 'max-speed'
> property on Ethernet devices already, which I think is probably
> sufficient to express the actual restrictions of some boards.

This is what I think as well. Maybe there is the need for something
more fine-grained, although I really doubt it.

>
>> +- phy-mii-manual-master: 1 to enable manual master/slave configuration, 0
>> +  to disable manual master/slave configuration
> [...]
>
> Although the standard calls this 'manual', if it's set in the DT it
> won't really be a manual setting.  The description should probably
> clarify that.
>
> I think the name should include 'master-slave' or 'clock-role' rather
> than just 'master', as currently it suggests only the master role can be
> forced.

Right, and this would match what 802.3-2008, Section 22.2.4.3.7 mentions.

>
> Ben.
>
> --
> Ben Hutchings
> friends: People who know you well, but like you anyway.



-- 
Florian
