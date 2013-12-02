Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab3LBNKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:10:22 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:52387 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab3LBNKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:10:18 -0500
MIME-Version: 1.0
X-Originating-IP: [121.6.203.106]
In-Reply-To: <CAMxnaaX67fnKS0bfmqeKR8WfEJUccpUCfwJVAkE57nNmHYic9w@mail.gmail.com>
References: <CAMVG2svSYPDEhs2vUMDi0jZ8vR9P9O5MmSnsd_ziDGcCe8aURg@mail.gmail.com>
	<CAMVG2ssN34fqjwmDezQVBeTOdt42tYQh92uS914pLbphqhk_EA@mail.gmail.com>
	<CAMxnaaX67fnKS0bfmqeKR8WfEJUccpUCfwJVAkE57nNmHYic9w@mail.gmail.com>
Date: Mon, 2 Dec 2013 21:10:18 +0800
Message-ID: <CAMVG2suDbSDO5-RKVjAtGNmKN=u_EOZYWeDNtr=bCKjDVxOM9w@mail.gmail.com>
Subject: Re: [PATCH 00/12] Thunderbolt hotplug support for Apple hardware
 (testers needed)
From: Daniel J Blueman <daniel@quora.org>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 December 2013 18:53, Andreas Noever <andreas.noever@gmail.com> wrote:
> On Mon, Dec 2, 2013 at 3:51 AM, Daniel J Blueman <daniel@quora.org> wrote:
>> On Friday, 29 November 2013 09:40:02 UTC+8, Andreas Noever  wrote:
>>
>> Booting with 3.12.2, your patch series, with acpi_osi=Darwin and no
>> thunderbolt devices plugged, I run into this oops:
>
> Ahh, I should have put a warning (since I spend about 3 hours to
> figure that out when updating from 3.12 to 3.13):
> 3.13 contains http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=498d319bb512992ef0784c278fa03679f2f5649d
> which means that kfifo_put now takes a value instead of a pointer. To
> run the driver on 3.12 try changing the kfifo_put in
> tb_ctl.c:tb_ctl_rx_callback to:
>                if (!kfifo_put(&cfg->response_fifo, &pkg)) {

Suspend issues aside, this works perfectly with 3.12 booted with
acpi_osi=Darwin in both thunderbolt ports with the Apple ethernet
adapter and my Buffalo MiniStation.

Great work!

Daniel
-- 
Daniel J Blueman
