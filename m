Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966800AbaCUAem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:34:42 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:52353 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965723AbaCUAek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:34:40 -0400
Message-ID: <532B891E.80705@hurleysoftware.com>
Date: Thu, 20 Mar 2014 20:34:38 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Bollinger, Seth" <Seth.Bollinger@digi.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>
Subject: Re: Possible software flow problem in serial_core
References: <CF505B08.6E64%seth.bollinger@digi.com> <532B743F.2030705@hurleysoftware.com> <CF50E0EB.6E95%seth.bollinger@digi.com>
In-Reply-To: <CF50E0EB.6E95%seth.bollinger@digi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 07:34 PM, Bollinger, Seth wrote:
> Do you have a driver that would be a good example of this?  From looking
> at serial_core.c:uart_start(), is seems that start_tx() is only called if
> the serial_core ring buffer is not empty.  If we don¹t stop the
> transmitter, we slew too many characters.

Yeah, you're right; thanks for catching this.
(I was busy looking at the ll driver and completely missed the bug in
the serial core).

uart_start() should not be conditioning the call to start_tx() on
the ring buffer being empty; ll drivers should already be able to handle
that because CTS flow control change will start_tx regardless of the ring
buffer count.

Will you send a patch?

Regards,
Peter Hurley
