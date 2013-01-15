Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab3AOPoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 10:44:25 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:43417 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab3AOPoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 10:44:23 -0500
MIME-Version: 1.0
In-Reply-To: <5313709.Qx2p1IPKbV@vostro.rjw.lan>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
	<6423213.ATyOvMNh1o@vostro.rjw.lan>
	<CAE9FiQU6+E+Tx4LTwZwAxX2cMQuoLPA5Cee8Lo0OaWgPQfixMQ@mail.gmail.com>
	<5313709.Qx2p1IPKbV@vostro.rjw.lan>
Date: Tue, 15 Jan 2013 07:44:21 -0800
X-Google-Sender-Auth: _V328TNOw4Fk6BpR89zPJUI4ls4
Message-ID: <CAE9FiQV1pvteSymLp=pHi=fNjHcfGe+TA84s2Ob9Tfne54fOmg@mail.gmail.com>
Subject: Re: [PATCH v8 02/22] PCI: Add root bus children dev's res to fail list
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 3:21 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, January 14, 2013 10:23:47 PM Yinghai Lu wrote:
>> On Sat, Jan 12, 2013 at 1:37 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Friday, January 11, 2013 02:40:29 PM Yinghai Lu wrote:
>> >> We can stop trying according to try number now and do not need to use
>> >> root_bus checking as stop sign anymore.
>> >>
>> >> In extreme case we could need to reallocate resource for device just
>> >> under root bus.
>> >
>> > Well, the above says that we _can_ do the change, but it doesn't explain why it
>> > is needed.  So what's the reason why we need to do that?
>>
>> In extreme case we could need to reallocate resource for device just
>> under root bus.
>>
>> otherwise, those devices just under root bus will not be assigned
>> resources again.
>
> IOW, our current code will not cover the case when we hot plug a host bridge
> and need to reassign resources for devices integrated into it?

yes. in extreme case if _CRS range is not big enough.
