Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbbAENwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:52:40 -0500
Received: from smtprelay4.synopsys.com ([198.182.47.9]:52251 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874AbbAENwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:52:38 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Peter Hurley <peter@hurleysoftware.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh@kernel.org" <robh@kernel.org>, "jslaby@suse.cz" <jslaby@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 2/3] serial: 8250_early: prepare for dynamic BASE_BAUD
Thread-Topic: [PATCH v2 2/3] serial: 8250_early: prepare for dynamic
 BASE_BAUD
Thread-Index: AQHQKNsX6WbkZQB8V0WNqr8z00JbjA==
Date: Mon, 5 Jan 2015 13:52:33 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307565BC9D66@IN01WEMBXA.internal.synopsys.com>
References: <1420457437-17636-1-git-send-email-vgupta@synopsys.com>
 <1420457437-17636-3-git-send-email-vgupta@synopsys.com>
 <54AA8AFC.9020706@hurleysoftware.com>
 <C2D7FE5348E1B147BCA15975FBA2307565BC9CCD@IN01WEMBXA.internal.synopsys.com>
 <54AA92C7.8070209@hurleysoftware.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.196.223]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 January 2015 07:04 PM, Peter Hurley wrote:
>> Also what do u think of the early IER optimization ?
> Seems ok except the commit changelog is wrong: IER is disabled twice per _line_.
> How did you profile it? It's ok if the answer is "seemed faster"; I'm just
> curious.

Looking at the code yes this would be per line - but I vaguely remember seeing it
for every char - this was when debugging a systemC model for 8250. Its been a while...
I'd added prints in the model whenever IER would wiggle and it was just being
written with 0's again and again when in the early polling based printing mode.

I'll send a revised version with fixed changelog.

Thx,
-Vineet
