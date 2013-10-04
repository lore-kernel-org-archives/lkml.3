Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab3JDMxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 08:53:22 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34147 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab3JDMxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 08:53:21 -0400
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>
Cc: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Daniel Mack <zonque@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH v2 0/2] rotary-encoder: Add new interruption handler
Date: Fri,  4 Oct 2013 09:53:21 -0300
Message-Id: <1380891203-17617-1-git-send-email-ezequiel@vanguardiasur.com.ar>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some rotary-encoder devices (such as those with detents) are capable
of producing a stable event on each step. This simple patch adds support
for this case, by implementing a new interruption handler.

The handler needs only detect the direction of the turn and generate
an event according to this detection.

We encode the previous and the current state, and then use the sum of them
to decide on the direction of the turn, according to the following simple
table:

Previous state + currrent state	| Movement
==========================================
	0b1101			| clockwise
	0b0100			|   ..
	0b0010			|   ..
	0b1011			|   ..
==========================================
	0b1110			| counter-clockwise
	0b0111			|   ..
	0b0001			|   ..
	0b1000			|   ..

(The other sumed values are considered illegal)

This calculation is based on some previous work found at this blog:

  http://bildr.org/2012/08/rotary-encoder-arduino/

The result is a seemingly very robust behavior, with a truly simple
implementation, that produces an event on each turn of the device.

Thanks!

Ezequiel Garcia (2):
  Input: rotary-encoder: Add 'stepped' irq handler
  input: rotary-encoder: Add 'on-each-step' to binding documentation

 .../devicetree/bindings/input/rotary-encoder.txt   |  1 +
 drivers/input/misc/rotary_encoder.c                | 41 ++++++++++++++++++++++
 include/linux/rotary_encoder.h                     |  1 +
 3 files changed, 43 insertions(+)

-- 
1.8.1.5

