Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbaHUMhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:37:23 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:49818 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbaHUMhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:37:22 -0400
MIME-Version: 1.0
In-Reply-To: <53F5E652.6050408@arm.com>
References: <1406306692-7135-1-git-send-email-sudeep.holla@arm.com>
	<1408618794-28497-1-git-send-email-sudeep.holla@arm.com>
	<1408618794-28497-4-git-send-email-sudeep.holla@arm.com>
	<CANq1E4Q4GRYUxrysUyTD5bO3di9M17i0H5V0fXb5+HrTrYY5aQ@mail.gmail.com>
	<53F5E652.6050408@arm.com>
Date: Thu, 21 Aug 2014 14:37:21 +0200
Message-ID: <CANq1E4S-PJvJeORnf-GZxHQZxPLOZ-R+hv9mu0w2g2O6zdfuVw@mail.gmail.com>
Subject: Re: [PATCH v3 03/11] drivers: base: add new class "cpu" to group cpu devices
From: David Herrmann <dh.herrmann@gmail.com>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Aug 21, 2014 at 2:30 PM, Sudeep Holla <sudeep.holla@arm.com> wrote:
> On 21/08/14 12:20, David Herrmann wrote:
>> Why do we need a cpu-class if the same set of information is already
>> available on the cpu-bus? Furthermore, classes are deprecated anyway.
>> Everything you can do with a class can be solved with a bus. And we
>> already have a bus for cpus.
>>
>
> This was suggested[1] by GregKH. The main reason it was added is to
> reuse the device attributes rather than creating the raw kobjects.
>
> It helps to move few other cpu related subsystems using raw kobjects to
> the device attribute groups.

So the only reason to add a class is to get attributes registered
properly with the device? Just set dev->groups before calling
device_add()? This works just fine on buses, too.

Thanks
David
