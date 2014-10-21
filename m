Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbaJUKI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:08:57 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43987 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751283AbaJUKIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:08:55 -0400
X-Sasl-enc: usDHosPNY6NThobSUXrOhYX6hPOGgGZasB4chry8ccc4 1413886134
Message-ID: <1413886132.32553.14.camel@localhost>
Subject: Re: RCU stall in af_unix.c, should use spin_lock_irqsave?
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandre FOURNIER <alexandre.fournier@wisp-e.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Gregory =?ISO-8859-1?Q?Cl=E9ment?= 
	<gregory.clement@free-electrons.com>
Date: Tue, 21 Oct 2014 12:08:52 +0200
In-Reply-To: <20141021100313.397f4962@free-electrons.com>
References: <20141021100313.397f4962@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Di, 2014-10-21 at 10:03 +0200, Thomas Petazzoni wrote:
> So, the question is: is this patch the correct solution (but then other
> usage of spin_lock in af_unix.c might also need fixing) ? Or is the
> network driver at fault?

It feels like a false positive. Do you see one core spinning tightly on
a lock? Does the system get unusable?

Bye,
Hannes


