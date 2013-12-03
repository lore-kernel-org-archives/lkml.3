Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab3LCKgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 05:36:55 -0500
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:33258 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752301Ab3LCKgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 05:36:53 -0500
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Dec 2013 05:36:53 EST
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1312030852410.24931@pobox.suse.cz>
References: <1386026244-21553-1-git-send-email-ogay@logitech.com> <alpine.LNX.2.00.1312030852410.24931@pobox.suse.cz>
From: Olivier Gay <ogay@logitech.com>
Date: Tue, 3 Dec 2013 11:30:00 +0100
Message-ID: <CAFLMSp-7X568ZdZ-JAAX9ttmMFhYP+DeLuc_-yCw1WCuvVAHng@mail.gmail.com>
Subject: Re: [PATCH] HID: logitech-dj: add HIDRAW dependency in Kconfig
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Mathieu Meisser <mmeisser@logitech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Tue, Dec 3, 2013 at 8:53 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> I don't have my receiver with me at the moment, so can't really verify --
> how exactly does it fail during probe()?

Hi Jiri,

Without hidraw driver, we get this:

<3>[  210.131988] logitech-djreceiver 0003:046D:C52B.0005: claimed by
neither input, hiddev nor hidraw
<3>[  210.132202] logitech-djreceiver 0003:046D:C52B.0005:
logi_dj_probe:hid_hw_start returned error

In logi_dj_probe, we call hid_hw_start with HID_CONNECT_DEFAULT
argument and if hidraw driver is not present, the call fails and we
return an error in logi_dj_probe.

> It's clear that without hidraw it's not possible to change the pairing
> from userspace, but I fail to see why probing the receiver should be
> affected?

As of today, hid-logitech-dj.c depends on hidraw API to work. All HID
reports sent to control / configure the receiver are sent using hidraw
API. That's why we fail logi_dj_probe if we cannot connect to hidraw.

Best regards,

Olivier
