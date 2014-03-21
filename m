Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760245AbaCUIV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 04:21:59 -0400
Received: from www.meduna.org ([92.240.244.38]:41025 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755017AbaCUIVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 04:21:55 -0400
Message-ID: <532BF695.3030900@meduna.org>
Date: Fri, 21 Mar 2014 09:21:41 +0100
From: Stanislav Meduna <stano@meduna.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: mxs-auart gives data from previous run after close and reopen
References: <5323625B.4010203@meduna.org> <532B985A.7060505@hurleysoftware.com>
In-Reply-To: <532B985A.7060505@hurleysoftware.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -6.9
X-Spam-Score-Int: -68
X-Exim-Version: 4.72 (build at 25-Oct-2012 18:35:58)
X-Date: 2014-03-21 09:21:46
X-Connected-IP: 95.105.163.217:1922
X-Message-Linecount: 38
X-Body-Linecount: 21
X-Message-Size: 1523
X-Body-Size: 749
X-Received-Count: 1
X-Recipient-Count: 5
X-Local-Recipient-Count: 5
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.03.2014 02:39, Peter Hurley wrote:

> Does disabling the fifo on shutdown clear the fifo?

I did not try this, but if my theory is correct, it would
not help, as all this does is reducing the FIFO length
to one character. So you'd still get up to two characters:
one in the "FIFO" - it could get there a microsecond after
you disable the FIFO before you gate the clock - and one
being received into the shift register (garbled by shutting
down the clock in the middle of the reception that was
resumed when clock was resumed on startup). Note that one
can get preempted here, so the instructions next to each
other can be milliseconds apart in reality.

IMHO we need a soft-reset here.

Regards
-- 
                                     Stano

