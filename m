Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbaDCPq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:46:59 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45879 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbaDCPqx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:46:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140403173701.75c1f497@north>
References: <1396534327-12971-1-git-send-email-richard.genoud@gmail.com> <20140403173701.75c1f497@north>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Thu, 3 Apr 2014 17:46:30 +0200
Message-ID: <CACQ1gAg8N+Y1=dvkZcA_KyLudfSB_ueL1+LS4F=2F2TE_JwtGA@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: BUG: remove double loop on REGISTER_BUSY_COUNT
To: =?UTF-8?Q?Jakub_Kici=C5=84ski?= <moorray3@wp.pl>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-03 17:37 GMT+02:00 Jakub Kiciński <moorray3@wp.pl>:
> On Thu,  3 Apr 2014 16:12:07 +0200, Richard Genoud wrote:
>> rt2x00usb_register_read_lock() calls rt2x00usb_vendor_req_buff_lock()
>> that calls rt2x00usb_vendor_request() which is already looping up to
>> REGISTER_BUSY_COUNT times.
>>
>> So this loop is not needed.
>
> Not true.  rt2x00usb_vendor_request() busy-waits for usb_control_msg()
> to succeed, rt2x00usb_register_read_lock() busy-waits for the register
> field itself to become 0.
>
> Also, how would this be a BUG?

Ok, you're right.
Just forget about this patch...

Richard
