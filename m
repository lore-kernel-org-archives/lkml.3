Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbaFPPi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:38:56 -0400
Received: from mx0.aculab.com ([213.249.233.131]:33225 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755363AbaFPPix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:38:53 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Peter Hurley'" <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "One Thousand Gnomes" <gnomes@lxorguk.ukuu.org.uk>,
        Karsten Keil <isdn@linux-pingi.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH tty-next 15/22] isdn: tty: Use private flag for
 ASYNC_CLOSING
Thread-Topic: [PATCH tty-next 15/22] isdn: tty: Use private flag for
 ASYNC_CLOSING
Thread-Index: AQHPiXhQEQlmfLWDUU+61Jx6pxqolZtz3m0Q
Date: Mon, 16 Jun 2014 15:37:44 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1725D13A@AcuExch.aculab.com>
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
 <1402924639-5164-16-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1402924639-5164-16-git-send-email-peter@hurleysoftware.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Of Peter Hurley
> ASYNC_CLOSING is no longer used in the tty core; use private flag
> info->closing as substitute.
...
> @@ -311,6 +311,7 @@ typedef struct atemu {
>  typedef struct modem_info {
>    int			magic;
>    struct tty_port	port;
> +  int			closing:1;	 /* port count has dropped to 0    */
>    int			x_char;		 /* xon/xoff character             */
>    int			mcr;		 /* Modem control register         */
>    int                   msr;             /* Modem status register          */

That should probably be a bool and set to true/false.
You are probably adding a load of padding.

	David



