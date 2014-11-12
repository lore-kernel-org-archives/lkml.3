Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaKLQ1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 11:27:14 -0500
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:48099
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753180AbaKLQ1J convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:27:09 -0500
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging: comedi: fix scan_end_arg == chanlist_len
 assumption
Thread-Topic: [PATCH] staging: comedi: fix scan_end_arg == chanlist_len
 assumption
Thread-Index: AQHP/pHeqLUkjDw/bk22uHH45dWbLJxdLU0g
Date: Wed, 12 Nov 2014 16:27:07 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D88260384E9@P3PWEX4MB008.ex4.secureserver.net>
References: <1415808048-2506-1-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1415808048-2506-1-git-send-email-abbotti@mev.co.uk>
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

On Wednesday, November 12, 2014 9:01 AM, Ian Abbott wrote:
> Some comedi drivers allow the `scan_end_arg` value of an asynchronous
> command to be a multiple (> 1) of the `chanlist_len` although most
> require them to be the same value.
>
> `comedi_bytes_per_scan()` is incorrectly using `chanlist_len` as the
> length of the scan.  Change it to use `scan_end_arg`.
>
> `comedi_nsamples_left()` is incorrectly using `cur_chan` as the current
> sample position in the scan (it is actually the current position in the
> channel list).  Change it to use the actual sample position in the scan.
> (Unfortunately we only have the current scan position in bytes currently,
> so convert that to a sample position.)
>
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> ---
>  drivers/staging/comedi/drivers.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

