Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab3LCMvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:51:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60031 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295Ab3LCMvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:51:46 -0500
Date: Tue, 3 Dec 2013 13:51:40 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Olivier Gay <ogay@logitech.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Mathieu Meisser <mmeisser@logitech.com>
Subject: Re: [PATCH] HID: logitech-dj: add HIDRAW dependency in Kconfig
In-Reply-To: <CAFLMSp-7X568ZdZ-JAAX9ttmMFhYP+DeLuc_-yCw1WCuvVAHng@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1312031350130.24931@pobox.suse.cz>
References: <1386026244-21553-1-git-send-email-ogay@logitech.com> <alpine.LNX.2.00.1312030852410.24931@pobox.suse.cz> <CAFLMSp-7X568ZdZ-JAAX9ttmMFhYP+DeLuc_-yCw1WCuvVAHng@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Dec 2013, Olivier Gay wrote:

> Without hidraw driver, we get this:
> 
> <3>[  210.131988] logitech-djreceiver 0003:046D:C52B.0005: claimed by
> neither input, hiddev nor hidraw
> <3>[  210.132202] logitech-djreceiver 0003:046D:C52B.0005:
> logi_dj_probe:hid_hw_start returned error
> 
> In logi_dj_probe, we call hid_hw_start with HID_CONNECT_DEFAULT
> argument and if hidraw driver is not present, the call fails and we
> return an error in logi_dj_probe.
> 
> > It's clear that without hidraw it's not possible to change the pairing
> > from userspace, but I fail to see why probing the receiver should be
> > affected?
> 
> As of today, hid-logitech-dj.c depends on hidraw API to work. All HID
> reports sent to control / configure the receiver are sent using hidraw
> API. That's why we fail logi_dj_probe if we cannot connect to hidraw.

Hmm, so unifying receiver is not claimed by hid-input at all? 
(HID_CONNECT_DEFAULT also contains HID_CONNECT_HIDINPUT) How so?

(again, I will not be able to test it with my receiver up until the day 
after tomorrow).

Thanks,

-- 
Jiri Kosina
SUSE Labs
