Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaDAPZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 11:25:50 -0400
Received: from m13-61.163.com ([220.181.13.61]:33037 "EHLO m13-61.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbaDAPZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 11:25:20 -0400
X-Originating-IP: [124.193.170.118]
Date: Tue, 1 Apr 2014 23:24:46 +0800 (CST)
From: "wei zhang" <asuka.com@163.com>
To: "Jesse Gross" <jesse@nicira.com>
Cc: "David Miller" <davem@davemloft.net>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        netdev <netdev@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] openvswitch: supply a dummy err_handler of
 gre_cisco_protocol to prevent kernel crash
X-Priority: 3
X-Mailer: Coremail Webmail Server Version SP_ntes V3.5 build
 20131204(24406.5820.5783) Copyright (c) 2002-2014 www.mailtech.cn 163com
In-Reply-To: <CAEP_g=_84HXCZLOzQ0JdLBF5WVhqwTJeEAY-xjqDD8YCv8yrRg@mail.gmail.com>
References: <1395957398-24546-1-git-send-email-asuka.com@163.com>
 <CAEP_g=_qJ1uHKZmZdkUrT+NUkzbRgaHfShZoMbnnCb+LwjOneQ@mail.gmail.com>
 <4fd27e6c.c96a.14512e82018.Coremail.asuka.com@163.com>
 <CAEP_g=_84HXCZLOzQ0JdLBF5WVhqwTJeEAY-xjqDD8YCv8yrRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <3586fbc4.12f75.1451de4826d.Coremail.asuka.com@163.com>
X-CM-TRANSID: PcGowAAX0ik_2jpTzHgHAA--.1670W
X-CM-SenderInfo: 5dvxytoofrzqqrwthudrp/1tbiPg1g1lD+SGq6HAABsu
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s31FQA7I004417

At 2014-04-01 08:49:53,"Jesse Gross" <jesse@nicira.com> wrote:
>On Sun, Mar 30, 2014 at 5:12 AM, wei zhang <asuka.com@163.com> wrote:
>> At 2014-03-29 06:02:25,"Jesse Gross" <jesse@nicira.com> wrote:

>> Maybe I misunderstand something? I think if we discard all packet pass to us
>> when we use gre vport, new gre_cisco_protocol which has lower priority could
>> not see the packet intended to it.
>
>That's true but in this case it would also not see any data packets,
>so I don't think that situation would work well anyways.
>
>> I checked the implementation of the ipgre_err(), which has be called before
>> the err_handler of gre vport. It use the the (local address, remote address, key)
>> to distinguish the packet which is realy intended to it, although it could not
>> always get the key from the icmp packet. Should we do as the same as it?
>> I'm not sure this is feasible, any advice is appreciate.
>
>OVS does flow based matching rather than using a static set of
>configuration parameters, so everything "matches" in some way
>(although the result might be to drop). 

So the flow based match could dynamically determine by the ovs daemon, we could
not find out the belonging of the packet as far as we call ovs_dp_upcall(), isn't it?

>This generally means that OVS
>is the receiver of last resort and nothing currently has a lower
>priority. 

Thanks for your kind help, this clarify my misunderstanding!

>That actually means the difference between the patches is
>somewhat academic but it seems more robust for the logic to be
>consistent.

Regards,
Wei Zhang 

���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
