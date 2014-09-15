Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbaIOSM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 14:12:58 -0400
Received: from p3plex2out03.prod.phx3.secureserver.net ([184.168.131.16]:57626
	"EHLO p3plex2out03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754270AbaIOSM5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 14:12:57 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 01/11] staging: comedi: add comedi_bytes_per_scan()
Thread-Topic: [PATCH 01/11] staging: comedi: add comedi_bytes_per_scan()
Thread-Index: AQHP0OMOJr4yzgDfe0mTwrvCk083IpwCfpkQ
Date: Mon, 15 Sep 2014 18:12:55 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825FA1B65@P3PWEX4MB008.ex4.secureserver.net>
References: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
 <1410785167-28506-2-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1410785167-28506-2-git-send-email-abbotti@mev.co.uk>
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

On Monday, September 15, 2014 5:46 AM, Ian Abbott wrote:
> The "comedi_fc" module contains a few functions useful to Comedi
> drivers.  Their functionality is being migrated to the core "comedi"
> module and renamed to start with the prefix `comedi_`.  As part of this
> migration, move `cfc_bytes_per_scan()` into the core comedi module and
> rename it to `comedi_bytes_per_scan()`.  Change the external declaration
> of `cfc_bytes_per_scan()` into an inline function that calls
> `comedi_bytes_per_scan()`.
>
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> ---
>  drivers/staging/comedi/comedidev.h         |  1 +
>  drivers/staging/comedi/drivers.c           | 37 ++++++++++++++++++++++++++++++
>  drivers/staging/comedi/drivers/comedi_fc.c | 22 ------------------
>  drivers/staging/comedi/drivers/comedi_fc.h |  6 ++++-
>  4 files changed, 43 insertions(+), 23 deletions(-)

Ian,

I think this function should be moved to comedi_buf.c instead.
It's only used by the drivers as part of the async command support.

Regards,
Hartley

