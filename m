Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966810Ab3E2UNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 16:13:08 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:34730 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966743Ab3E2UM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 16:12:56 -0400
MIME-Version: 1.0
In-Reply-To: <1369817109-4277-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1369817109-4277-1-git-send-email-benjamin.tissoires@redhat.com>
Date: Wed, 29 May 2013 23:12:54 +0300
Message-ID: <CAHp75VcpdQqd+evBNhwMGHvXwCoVdaXYdBqQeSDGwt25dLkpGQ@mail.gmail.com>
Subject: Re: [PATCH] HID: multitouch: prevent memleak with the allocated name
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 11:45 AM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> mt_free_input_name() was never called during .remove():
> hid_hw_stop() removes the hid_input items in hdev->inputs, and so the
> list is therefore empty after the call. In the end, we never free the
> special names that has been allocated during .probe().
>
> Restore the original name before freeing it to avoid acessing already
> freed pointer.
>

> I just spotted this one yesterday... My guess is that this way is safe (without
> a locking mechanism to prevent accessing hi->input->name), but I'm not 100% sure.

Hi Jiri, Benjamin.

What do you think about patch I just sent?

P.S. Benjamin, I re-used your commit message, I think you have no objections.

--
With Best Regards,
Andy Shevchenko
