Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbaKTP1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:27:19 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:42123 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137AbaKTP1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:27:15 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1411201421100.4454@pobox.suse.cz>
References: <1416422480-3241-1-git-send-email-mathieu.magnaudet@enac.fr>
	<CAN+gG=GN4dwXr_qEHMfMddGHkMKECZMUwTM+xbNmY_gibthLmA@mail.gmail.com>
	<alpine.LNX.2.00.1411201421100.4454@pobox.suse.cz>
Date: Thu, 20 Nov 2014 10:27:14 -0500
Message-ID: <CAN+gG=F5AENtv0a-sK3WmvYLdVUWEyteXce1avX7+eRSeOAswQ@mail.gmail.com>
Subject: Re: [PATCH] hid-multitouch: Add quirk for VTL touch panels
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Mathieu Magnaudet <mathieu.magnaudet@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 8:21 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 19 Nov 2014, Benjamin Tissoires wrote:
>
>> though this patch works for this particular device, I just thought at
>> something which may solve the problem in a different way. I asked
>> Mathieu to test the different solution, so I'd rather you to wait for
>> final confirmation before merging this patch.
>
> Thanks for the heads up, I am putting this patch on hold until further
> notice from you or Mathieu.
>

Mathieu confirmed this morning that using hid_hw_raw_request instead
of hid_hw_request while _setting_ the input_mode works for this
particular touchscreen. So I think we will simply switch to use this
sync operation instead of relying on the async one. We will need to
test this change a little bit, but it should be safe for BT and I2C at
least.

So, yes, we will drop this patch and have a better one in the next few
days. Thanks for holding this one :)

Cheers,
Benjamin
