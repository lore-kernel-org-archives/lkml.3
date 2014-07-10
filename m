Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaGJOjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 10:39:18 -0400
Received: from mx0.aculab.com ([213.249.233.131]:51012 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752605AbaGJOjP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 10:39:15 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Olivier Sobrie'" <olivier@sobrie.be>, David Miller <davem@davemloft.net>
CC: "j.dumon@option.com" <j.dumon@option.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] hso: fix deadlock when receiving bursts of data
Thread-Topic: [PATCH 2/2] hso: fix deadlock when receiving bursts of data
Thread-Index: AQHPnEsixGodlQaSuk2Kj0YtzGiNipuZYB6g
Date: Thu, 10 Jul 2014 14:37:37 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D17270044@AcuExch.aculab.com>
References: <1404723967-24245-1-git-send-email-olivier@sobrie.be>
 <1404723967-24245-2-git-send-email-olivier@sobrie.be>
 <20140708.161633.2130069042930765600.davem@davemloft.net>
 <20140710142848.GA28056@hposo>
In-Reply-To: <20140710142848.GA28056@hposo>
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
...
> The function put_rxbuf_data() is called from the urb completion handler.
> It puts the data of the urb transfer in the tty buffer with
> tty_insert_flip_string_flags() and schedules a work queue in order to
> push the data to the ldisc.
> Problem is that we are in a urb completion handler so we can't wait
> until there is room in the tty buffer.

Surely you can just keep the urb?
Resubmit it later when all the data has been transferred.

	David



