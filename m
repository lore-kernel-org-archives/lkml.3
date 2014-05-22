Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaEVHcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 03:32:12 -0400
Received: from mail.southpole.se ([37.247.8.11]:44899 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbaEVHcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 03:32:11 -0400
Message-ID: <537DA7F5.6010704@southpole.se>
Date: Thu, 22 May 2014 09:32:05 +0200
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, linux@openrisc.net,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v2] openrisc: irq: use irqchip framework
References: <1400530303-29182-1-git-send-email-stefan.kristiansson@saunalahti.fi> <alpine.DEB.2.02.1405200809260.5204@ionos.tec.linutronix.de> <20140521195056.GA14701@chokladfabriken.org>
In-Reply-To: <20140521195056.GA14701@chokladfabriken.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.4.1(14132) on assp.southpole.se
X-Assp-ID: assp.southpole.se 43922-13103
X-Assp-Session: 7F468A9482A0 (mail 1)
X-Assp-Client-TLS: yes
X-Assp-Server-TLS: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2014 09:50 PM, Stefan Kristiansson wrote:
> 
> I see two paths to go to get there though, and here's where I'd like some input.
> 1) Define the three different implementations as seperate irqchips,
>    with accompanying IRQCHIP_DECLARE.
> 2) Add custom device-tree bindings and determine the chip type from that.

I think 1) above is the way to go.  Something alone the lines of
"opencores,or1k-pic-level", "opencores,or1k-pic-edge", and
"opencores,or1200-pic".

The first two match the behaviour of the or1k specification; the third
one, however, is really a misimplementation of the spec and is kind of
tied to the actual implementation of the OR1200... I wonder if we don't
need to version this one like we version the CPU identifier (*-rtlsvnXXXXX).

/Jonas
