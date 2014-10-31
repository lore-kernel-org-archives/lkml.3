Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798AbaJaQVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:21:43 -0400
Received: from p3plex2out03.prod.phx3.secureserver.net ([184.168.131.16]:52995
	"EHLO p3plex2out03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753046AbaJaQVl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:21:41 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/2] staging: comedi: das16: fix some timer sync issues
Thread-Topic: [PATCH 0/2] staging: comedi: das16: fix some timer sync issues
Thread-Index: AQHP8569lWwrWNQ84Uey0o4bwk91C5xKZc+Q
Date: Fri, 31 Oct 2014 16:21:40 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D882601A692@P3PWEX4MB008.ex4.secureserver.net>
References: <1414604112-4362-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1414604112-4362-1-git-send-email-abbotti@mev.co.uk>
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

On Wednesday, October 29, 2014 10:35 AM, Ian Abbott wrote:
> "das16" uses a kernel timer but never removes it from the queue
> synchronously at the moment.  Patch 1 makes sure this is done before it
> is destroyed.  Patch 2 uses the comedi device's main spin-lock to ensure
> some state shared with the timer routine is updated in an SMP-safe
> manner.
>
> 1) staging: comedi: das16: deschedule timer routine on detach
> 2) staging: comedi: das16: use spin-lock when setting timer
>
>  drivers/staging/comedi/drivers/das16.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

