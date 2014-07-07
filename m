Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbaGGJPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 05:15:22 -0400
Received: from mx0.aculab.com ([213.249.233.131]:34092 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751769AbaGGJPS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 05:15:18 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Olivier Sobrie'" <olivier@sobrie.be>, Jan Dumon <j.dumon@option.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] hso: fix deadlock when receiving bursts of data
Thread-Topic: [PATCH 2/2] hso: fix deadlock when receiving bursts of data
Thread-Index: AQHPmcLSZHvd9YpRyUuWSgEqOO1egZuUU3eA
Date: Mon, 7 Jul 2014 09:13:53 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1726D5E9@AcuExch.aculab.com>
References: <1404723967-24245-1-git-send-email-olivier@sobrie.be>
 <1404723967-24245-2-git-send-email-olivier@sobrie.be>
In-Reply-To: <1404723967-24245-2-git-send-email-olivier@sobrie.be>
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

From: Olivier Sobrie
> When the module sends bursts of data, sometimes a deadlock happens in
> the hso driver when the tty buffer doesn't get the chance to be flushed
> quickly enough.
> 
> To avoid this, first, we remove the endless while loop in
> put_rx_bufdata() which is the root cause of the deadlock.
> Secondly, when there is no room anymore in the tty buffer, we set up a
> timer of 100 msecs to give a chance to the upper layer to flush the tty
> buffer and make room for new data.

What is the timer for?
You need to get the sending code woken up by the urb completion.

	David



