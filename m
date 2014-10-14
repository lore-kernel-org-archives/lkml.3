Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575AbaJNWVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 18:21:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46744 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734AbaJNWVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 18:21:31 -0400
Date: Tue, 14 Oct 2014 15:21:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hyogi Gim <ciogenis@gmail.com>
Cc: a.zummo@towertech.it, john.stultz@linaro.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/rtc/interface.c: check the validation of
 rtc_time in __rtc_read_time
Message-Id: <20141014152131.1442b937e3010a558c7798a6@linux-foundation.org>
In-Reply-To: <20141008020529.GA21464@lge.com>
References: <20141008020529.GA21464@lge.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Oct 2014 11:05:29 +0900 Hyogi Gim <ciogenis@gmail.com> wrote:

> Some of rtc devices always return '0' when rtc_class_ops.read_time is called.
> So if rtc_time isn't verified in callback, rtc interface cannot know whether
> rtc_time is valid.

We should fix the buggy .read_time() implementations...

> Check rtc_time by using 'rtc_valid_tm' in '__rtc_read_time'. And add the
> message for debugging.
> 

