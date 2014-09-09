Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbaIIQ2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:28:41 -0400
Received: from p3plex2out03.prod.phx3.secureserver.net ([184.168.131.16]:41699
	"EHLO p3plex2out03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752224AbaIIQ2k convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:28:40 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 00/48] staging: comedi: avoid using comedi_board()
Thread-Topic: [PATCH 00/48] staging: comedi: avoid using comedi_board()
Thread-Index: AQHPzBidpyB9E37aHUyfPTFUHQsjBpv4+L0g
Date: Tue, 9 Sep 2014 16:28:38 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825F92FAE@P3PWEX4MB008.ex4.secureserver.net>
References: <1410258417-28230-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1410258417-28230-1-git-send-email-abbotti@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 09, 2014 3:26 AM, Ian Abbott wrote:
>
> The `comedi_board` inline function takes a single parameter of type
> `struct comedi_device *` and merely returns the value of the `board_ptr`
> member therein.  This is somewhat superfluous as the member can be
> accessed directly.
>
> Replace all uses of `comedi_board(dev)` with `dev->board_ptr`.
>
> Note, if there are any conflicts when applying this series, they can
> just be skipped for now and corrected later.
> 
> A subsequent patch will remove the `comedi_board` function, once there
> is nothing using it.

I would argue that the comedi_board() inline is a bit cleaner.

But, since all the goofy macros and private boardinfo access functions in
the drivers have been removed I guess this can go now. We will need
to make that sure any new drivers don't introduce new goofy macros
or access functions. The 'board(dev)->foo' ones really made the drivers
hard to read...

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

