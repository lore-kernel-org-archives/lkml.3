Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab3A2X6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 18:58:40 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:55487 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751067Ab3A2X6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 18:58:39 -0500
Message-ID: <1359503917.16868.24.camel@joe-AO722>
Subject: Re: [Q]staging/comedi: Considation of *_find_boardinfo possible?
From: Joe Perches <joe@perches.com>
To: Peter =?ISO-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Date: Tue, 29 Jan 2013 15:58:37 -0800
In-Reply-To: <201301300041.36064.PeterHuewe@gmx.de>
References: <201301300041.36064.PeterHuewe@gmx.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-30 at 00:41 +0100, Peter Hüwe wrote:
> ---> is there a way to consolidate these functions into one function (which 
> can operate on the different types) ?  It's almost a bit like 'templates'.
> Maybe with some gcc extensions or kernel magic functions ?

Nothing wrong with a macro.

Maybe something like:

#define comedi_find_board(array, board_id)		\
({							\
	int i;						\
	typeof array *p = array;			\
	typeof array *rtn = NULL;			\
	for (i = 0; i < ARRAY_SIZE(array); i++, p++) {	\
		if (p->device_id == board_id) {		\
			rtn = p;			\
			break;				\
		}					\
	}						\
	rtn;						\
})


