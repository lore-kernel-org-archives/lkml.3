Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbbAEOF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:05:59 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:61356 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbbAEOF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:05:56 -0500
Message-ID: <54AA9A35.2000806@hurleysoftware.com>
Date: Mon, 05 Jan 2015 09:05:41 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh@kernel.org" <robh@kernel.org>, "jslaby@suse.cz" <jslaby@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 2/3] serial: 8250_early: prepare for dynamic BASE_BAUD
References: <1420457437-17636-1-git-send-email-vgupta@synopsys.com> <1420457437-17636-3-git-send-email-vgupta@synopsys.com> <54AA8AFC.9020706@hurleysoftware.com> <C2D7FE5348E1B147BCA15975FBA2307565BC9CCD@IN01WEMBXA.internal.synopsys.com> <54AA92C7.8070209@hurleysoftware.com> <C2D7FE5348E1B147BCA15975FBA2307565BC9D66@IN01WEMBXA.internal.synopsys.com>
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA2307565BC9D66@IN01WEMBXA.internal.synopsys.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2015 08:52 AM, Vineet Gupta wrote:
> On Monday 05 January 2015 07:04 PM, Peter Hurley wrote:
>>> Also what do u think of the early IER optimization ?
>> Seems ok except the commit changelog is wrong: IER is disabled twice per _line_.
>> How did you profile it? It's ok if the answer is "seemed faster"; I'm just
>> curious.
> 
> Looking at the code yes this would be per line - but I vaguely remember seeing it
> for every char - this was when debugging a systemC model for 8250. Its been a while...
> I'd added prints in the model whenever IER would wiggle and it was just being
> written with 0's again and again when in the early polling based printing mode.

Maybe that was while running kgdb through serial8250_put_poll_char(), which is
per-char.

Regards,
Peter Hurley

