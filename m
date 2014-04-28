Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbaD1WgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 18:36:15 -0400
Received: from p3plex2out02.prod.phx3.secureserver.net ([184.168.131.14]:58291
	"EHLO p3plex2out02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752711AbaD1WgO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 18:36:14 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Christian Engelmayer <cengelma@gmx.at>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "chase.southwood@yahoo.com" <chase.southwood@yahoo.com>,
        "unixed@gmail.com" <unixed@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging: comedi: remove duplicate pointer assignments
 in attach functions
Thread-Topic: [PATCH] staging: comedi: remove duplicate pointer assignments
 in attach functions
Thread-Index: AQHPYViIqQFkLdDwSE2oh2oh2YYWSZsnnxcw
Date: Mon, 28 Apr 2014 22:36:13 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825E2096F@P3PWEX4MB008.ex4.secureserver.net>
References: <20140426160429.4883f678@spike>
In-Reply-To: <20140426160429.4883f678@spike>
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

On Saturday, April 26, 2014 7:04 AM, Christian Engelmayer wrote:
> Some board pointer are assigned twice via comedi_board() in the comedi low
> level driver attach functions. Remove the duplicate assignment from the
> variable definition where the pointer is not used anyway until assigned later
> in the function when dev->board_ptr, that comedi_board() relies on, is setup
> correctly.
>
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> ---
> Compile tested and applies against v3.15-rc2 as well as branch staging-next
> of tree git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> ---
>  drivers/staging/comedi/drivers/das1800.c     | 2 +-
>  drivers/staging/comedi/drivers/das800.c      | 2 +-
>  drivers/staging/comedi/drivers/dt2801.c      | 2 +-
>  drivers/staging/comedi/drivers/ni_at_a2150.c | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)

Technically, these drivers are fine as-is.

They are all legacy comedi drivers and use the manual attach mechanism. The
dev->board pointer is setup by the comedi core before calling the drivers
(*attach) so the foo = comedi_board(dev) is getting the board pointer that
was found by the core.

Unlike most comedi legacy drivers, these drivers then do an additional "probe"
to try and identify the board. This could result in the dev->board_ptr getting
changed which requires updating the local variable for the board pointer.

These probe functions need to be looked at to see if they are actually needed.

For now I would prefer that the existing code stay as-is.

Regards,
Hartley

