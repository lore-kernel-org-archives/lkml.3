Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760575AbaCUKRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 06:17:18 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:55609 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755407AbaCUKRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 06:17:16 -0400
Message-ID: <532C11A4.7080807@hurleysoftware.com>
Date: Fri, 21 Mar 2014 06:17:08 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stanislav Meduna <stano@meduna.org>
CC: linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: mxs-auart gives data from previous run after close and reopen
References: <5323625B.4010203@meduna.org> <532B985A.7060505@hurleysoftware.com> <532BF695.3030900@meduna.org>
In-Reply-To: <532BF695.3030900@meduna.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 04:21 AM, Stanislav Meduna wrote:
> On 21.03.2014 02:39, Peter Hurley wrote:
>
>> Does disabling the fifo on shutdown clear the fifo?
>
> I did not try this, but if my theory is correct, it would
> not help, as all this does is reducing the FIFO length
> to one character. So you'd still get up to two characters:
> one in the "FIFO" - it could get there a microsecond after
> you disable the FIFO before you gate the clock - and one
> being received into the shift register (garbled by shutting
> down the clock in the middle of the reception that was
> resumed when clock was resumed on startup). Note that one
> can get preempted here, so the instructions next to each
> other can be milliseconds apart in reality.
>
> IMHO we need a soft-reset here.

The reason why I asked about disabling the fifo is
because on other uarts, changing from non-fifo to fifo
mode clears the fifo. The idea being that, on shutdown,
if the uart is changed to non-fifo mode then, on startup,
the uart will be changed back to fifo mode, clearing the
fifo.

Unfortunately, the i.mx28 reference doesn't say what
happens to the data when the fifo is reconfigured this
way, and why I suggested the experiment.

Regards,
Peter Hurley

