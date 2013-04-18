Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030273Ab3DRKRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:17:15 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:36261 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967868Ab3DRKNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:13:12 -0400
Message-ID: <516FC732.9080109@atmel.com>
Date: Thu, 18 Apr 2013 12:13:06 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: <dgilbert@interlog.com>, <robertcnelson@gmail.com>
CC: <jhovold@gmail.com>, <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>,
        "Sergio Tanzilli" <tanzilli@acmesystems.it>
Subject: Re: [PATCH v3] ARM: at91: add Acme Systems Aria G25 board
References: <20130402184947.GA8015@quad.lixom.net> <1365090153-1807-1-git-send-email-nicolas.ferre@atmel.com> <515DB248.6070105@interlog.com> <516FB671.2030706@atmel.com>
In-Reply-To: <516FB671.2030706@atmel.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2013 11:01 AM, Nicolas Ferre :
> On 04/04/2013 07:03 PM, Douglas Gilbert :

[..]

>> The lack of use of uart1 is for my own, private reasons.
>> I think it would be more generally useful to show uart1's
>> definition and disable it as shown in the attached patch
>> fragment.
> 
> Well, if uart1 is available on Aria board, I should enable it! If you do
> not want it on your own design, you must modify the .dts yourself. So I
> plan to have an "okay" status on it (and move the definition itself to
> the generic .dtsi).

Update: I have just checked the ACME website and both UART0 and UART1
pins are expected to be used as GPIOs. So maybe we should mark them as
"disabled":

+                       /*
+                        * UART1 pins are marked as GPIO on Aria
+                        * documentation: change to "okay" if you need
+                        * an additional serial port
+                        */
+                       uart0: serial@f8040000 {
+                               status = "disabled";
+                       };
+
+                       uart1: serial@f8044000 {
+                               status = "disabled";
+                       };

(uart0 definition moved to at91sam9x5.dtsi)
What do you think?

[..]

Bye,
-- 
Nicolas Ferre
