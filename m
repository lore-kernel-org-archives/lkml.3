Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089Ab3GCQQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 12:16:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40122 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932915Ab3GCQQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 12:16:44 -0400
Date: Wed, 3 Jul 2013 18:16:40 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: kye: Add report fixup for Genius Gila Gaming
 mouse
In-Reply-To: <1372781409-5356-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1307031815570.26857@pobox.suse.cz>
References: <1372781409-5356-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jul 2013, Benjamin Tissoires wrote:

> Genius Gila Gaming Mouse presents an obviously wrong report descriptor.
> the Consumer control (report ID 3) is the following:
> 0x05, 0x0c,                    // Usage Page (Consumer Devices)       105
> 0x09, 0x01,                    // Usage (Consumer Control)            107
> 0xa1, 0x01,                    // Collection (Application)            109
> 0x85, 0x03,                    //   Report ID (3)                     111
> 0x19, 0x00,                    //   Usage Minimum (0)                 113
> 0x2a, 0xff, 0x7f,              //   Usage Maximum (32767)             115
> 0x15, 0x00,                    //   Logical Minimum (0)               118
> 0x26, 0xff, 0x7f,              //   Logical Maximum (32767)           120
> 0x75, 0x10,                    //   Report Size (16)                  123
> 0x95, 0x03,                    //   Report Count (3)                  125
> 0x81, 0x00,                    //   Input (Data,Arr,Abs)              127
> 0x75, 0x08,                    //   Report Size (8)                   129
> 0x95, 0x01,                    //   Report Count (1)                  131
> 0x81, 0x01,                    //   Input (Cnst,Arr,Abs)              133
> 0xc0,                          // End Collection                      135
> 
> So the first input whithin this report has a count of 3 but a usage range
> of 32768. So this value is obviously wrong as it should not be greater than
> the report count.
> 
> Fixes:
> https://bugzilla.redhat.com/show_bug.cgi?id=959721
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
> Hi Jiri,
> 
> I know the window just opened and you don't really like receiving patches at
> that time. Still, my patch queue is growing, and I would like you to consider
> this patch for 3.11.

This one is really easy enough to go into even post -rc1 :) Now applied 
for the Linus merge I am going to do shortly.

Thanks a lot, Benjamin.

-- 
Jiri Kosina
SUSE Labs
