Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab3EHPtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:49:03 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65227 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018Ab3EHPtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:49:00 -0400
Date: Wed, 8 May 2013 17:48:55 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Stas Sergeev <stsp@list.ru>
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        Jarkko Huijts <jarkko.huijts@gmail.com>,
        Alan Cox <alan@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Caylan Van Larson <i@caylan.net>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 2/7] USB: serial: add generic wait_until_sent
 implementation
Message-ID: <20130508154855.GA14438@localhost>
References: <20130505182913.GE16818@localhost>
 <1367778753-22297-1-git-send-email-jhovold@gmail.com>
 <1367778753-22297-3-git-send-email-jhovold@gmail.com>
 <518A6049.4090303@list.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <518A6049.4090303@list.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 06:25:13PM +0400, Stas Sergeev wrote:
> 05.05.2013 22:32, Johan Hovold пишет:
> > Add generic wait_until_sent implementation which polls for empty
> > hardware buffers using the new port-operation tx_empty.
> >
> > The generic implementation will be used for all sub-drivers that
> > implement tx_empty but does not define wait_until_sent.
> Hi Johan.
> 
> The customer reports an Oops below.
> Does that ring any bells?
> Well, there is only one division in usb_serial_generic_wait_until_sent(),
> anyway. :)

Yes, you're right I forgot about B0. I'll send a v2.

Thanks for catching this,
Johan
