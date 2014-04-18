Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaDRIMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 04:12:38 -0400
Received: from mout.gmx.net ([212.227.17.21]:62850 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbaDRIMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 04:12:14 -0400
Message-ID: <5350DDE9.1040102@gmx.at>
Date: Fri, 18 Apr 2014 10:10:17 +0200
From: Manfred Schlaegl <manfred.schlaegl@gmx.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>,
        Alan Cox <alan@redhat.com>, linux-kernel@vger.kernel.org,
        Manfred Schlaegl <manfred.schlaegl@ginzinger.com>
Subject: Re: [PATCH] tty: Fix race condition between __tty_buffer_request_room
 and flush_to_ldisc
References: <5343EE9C.9010004@gmx.at>
In-Reply-To: <5343EE9C.9010004@gmx.at>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Provags-ID: V03:K0:PPD8AK1tAYcJVOzWGa+99QRP7CVd/bY1cM8yQ/AfAC0lH/+UH2j
 vts8pebKnmB0OJab86Qh2jq00V4pPQLcul7tXLulzP6Cs2tpLpbtBBU2cPY1UJQjXmp45Vb
 q1TdFCGi7QIy0RH1vqYdLxa21qa/zyw32L/N8PQ77QoAo3BWDq3qeEKMD9hUgRQkYbv0WE1
 DuAshvg014hf03waN19vg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-08 14:42, Manfred Schlaegl wrote:
> The race was introduced while development of linux-3.11 by
> e8437d7ecbc50198705331449367d401ebb3181f and
> e9975fdec0138f1b2a85b9624e41660abd9865d4.
> Originally it was found and reproduced on linux-3.12.15 and
> linux-3.12.15-rt25, by sending 500 byte blocks with 115kbaud to the
> target uart in a loop with 100 milliseconds delay.
> 
> In short:
>  1. The consumer flush_to_ldisc is on to remove the head tty_buffer.
>  2. The producer adds a number of bytes, so that a new tty_buffer must
> 	be allocated and added by __tty_buffer_request_room.
>  3. The consumer removes the head tty_buffer element, without handling
> 	newly committed data.

Hi!

Reminder: The Problem is still existent in linux-3.11, 3.12, 3.13. 3.14 and pre 3.15 kernels.

The lastly delivered patch cleanly applies to pre 3.15 (torvalds tree) and 3.14(.1).

Manfred
