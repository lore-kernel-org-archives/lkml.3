Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaBLKZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:25:44 -0500
Received: from mail-qc0-f194.google.com ([209.85.216.194]:58993 "EHLO
	mail-qc0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbaBLKZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:25:40 -0500
MIME-Version: 1.0
Date: Wed, 12 Feb 2014 04:25:39 -0600
Message-ID: <CAM83q7AiCBc5qSH18KhBHYknYf67Pnjkd3JUbC_WrBwefxHJMg@mail.gmail.com>
Subject: Experimental Privacy Functions and TCP SYN Payloads
From: Quinn Wood <wood.quinn.s@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If program on host A spoofs the source address of an outgoing IPv4 packet then
places that address in the first 32 bits of a UDP payload, a program on host B
that is aware of these behaviors can still reply to the program on host A. [1]

Continuing with this approach the program on host A could encrypt the UDP pay-
load in a way that the program on host B can decrypt, and effectively reduce
the ability of others in the wide network to passively determine who host A is
sending transmissions to while simultaneously ensuring the program on host B
can respond to the program on host A. [2]

I'm uncertain how to proceed if I want to use TCP for stateful connections.
The requirement of a handshake before data is handed off to the program means
this approach won't work out of the box. I'm looking for any insight folks may
have regarding this.

My original approach to the handshake included setting one of the reserved
bits in the TCP header to indicate the first 32 bits of the payload were the
real source address. However this would be reliant on SYN packets containing
a payload. Does the Linux kernel allow this?

-

[1] Barring any non store-and-forward network behavior like dropping packets
    with questionable source addresses. Considering recent NTP-related  news
    this seems to be a not-entirely common activity :)
[2] This is of course reliant on both programs knowing the proper key for the
    other.
