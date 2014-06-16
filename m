Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbaFPVBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:01:35 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:59965 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755835AbaFPVBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:01:33 -0400
Message-ID: <539F5B28.9080000@hurleysoftware.com>
Date: Mon, 16 Jun 2014 17:01:28 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Karsten Keil <isdn@linux-pingi.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH tty-next 15/22] isdn: tty: Use private flag for ASYNC_CLOSING
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com> <1402924639-5164-16-git-send-email-peter@hurleysoftware.com> <063D6719AE5E284EB5DD2968C1650D6D1725D13A@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1725D13A@AcuExch.aculab.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 06/16/2014 11:37 AM, David Laight wrote:
> From: Of Peter Hurley
>> ASYNC_CLOSING is no longer used in the tty core; use private flag
>> info->closing as substitute.
> ...
>> @@ -311,6 +311,7 @@ typedef struct atemu {
>>   typedef struct modem_info {
>>     int			magic;
>>     struct tty_port	port;
>> +  int			closing:1;	 /* port count has dropped to 0    */
>>     int			x_char;		 /* xon/xoff character             */
>>     int			mcr;		 /* Modem control register         */
>>     int                   msr;             /* Modem status register          */
>
> That should probably be a bool and set to true/false.
> You are probably adding a load of padding.

struct modem_info is over 1K, with several existing int-as-bool fields.
An array of 64 struct modem_info are statically allocated with every isdn device.

It doesn't look like memory consumption has been a consideration with the isdn driver.

Regards,
Peter Hurley
