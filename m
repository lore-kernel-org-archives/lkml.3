Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab3FYOwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 10:52:40 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:59053 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab3FYOwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 10:52:39 -0400
MIME-Version: 1.0
Date: Tue, 25 Jun 2013 16:52:37 +0200
Message-ID: <CA+xJJ1-MU_g8tXsvX63ongAZu+1OynnG_PRv4VoZdKHng1qjWg@mail.gmail.com>
Subject: Question: How to find clock source with no consumer device node?
From: Mats Liljegren <liljegren.mats2@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I want to make a load module which is used for performance
measurements. It hooks into a timer available with the target board in
question.

Now, there is no device tree information about this timer hardware
that my load module could use. However, there is device tree
information about the clock source that my timer needs. But I can't
figure out how get the clock based on this.

I do not want to force the user of this load module to patch and
regenerate their device tree blob, and then restart their computer, to
get the right information in. I have tried this path and sure enough,
it works for me. But it will not be so easy for someone else who just
want to run this load module.

I tried to use "clk_get_sys()", but apparently you can't point at the
clock producer, you must point at the clock consumer, which would be
my timer. But this device node does not exist.

I would really like to just say "clk_of_get("/soc/clocks/myclock")"
where "/soc/clocks/myclock" is the device tree path to the clock
device I want to use.

Any help or hints are appreciated.

/Mats
