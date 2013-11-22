Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab3KVM0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 07:26:05 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:39360 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab3KVM0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 07:26:03 -0500
MIME-Version: 1.0
In-Reply-To: <CAHj3AVk2ya1mgXt_ODt_rMZSf0enzH-WonD6ze73B_fR4dRDWg@mail.gmail.com>
References: <cover.1384933520.git.gamerh2o@gmail.com>
	<c55eeb3252a868e9e62655baed8d6b11992b9cbe.1384933520.git.gamerh2o@gmail.com>
	<20131121211920.GC10691@einon.net>
	<CAHj3AV=xiW76y_bqP5h6sprokfphj5WquF32EGzJ-YqOyoj9-w@mail.gmail.com>
	<CAAb+SYagm1UeJycq6Y9GqfU1C=HbRYKUmFfHdejT7bekonGceQ@mail.gmail.com>
	<CAHj3AVk2ya1mgXt_ODt_rMZSf0enzH-WonD6ze73B_fR4dRDWg@mail.gmail.com>
Date: Fri, 22 Nov 2013 20:26:02 +0800
Message-ID: <CAAb+SYaMYV1XO2B8fhcPVvE2mTj-o8+qiesgz8jh9Y796iDC_Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] staging: et131x: drop packet when error occurs in et131x_tx
From: ZHAO Gang <gamerh2o@gmail.com>
To: Denis Kirjanov <kirjanov@gmail.com>
Cc: Mark Einon <mark.einon@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        STAGING SUBSYSTEM <devel@driverdev.osuosl.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 7:56 PM, Denis Kirjanov <kirjanov@gmail.com> wrote:
> If you have no free TX descriptors that means that something went
> wrong and it's a BUG. You have to tell the stack to stop sending
> packets using netif_stop_queue() and reenable transmissions once tx
> descriptors will be available. There are a lot of live examples in the
> source tree.
>
The stop queue code dose not show in the diff, actually it is at the
beginning of et131x_tx:

/* stop the queue if it's getting full */
if (adapter->tx_ring.used >= NUM_TCB - 1 &&
    !netif_queue_stopped(netdev))
        netif_stop_queue(netdev);

I think the logic is when there is only one descriptor left, stop the
queue and transmit this packet, if tx queue is full, it must have been
stopped, so just drop the packet.

Cheers
