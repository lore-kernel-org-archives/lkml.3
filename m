Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab3HRTwG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 15:52:06 -0400
Received: from mx-out.ocsa-data.net ([194.36.166.37]:57967 "EHLO
	mx-out.ocsa-data.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab3HRTwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 15:52:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Sun, 18 Aug 2013 21:52:01 +0200
From: Yann Droneaud <ydroneaud@opteya.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: serial: fix stringify operator in usb-serial-simple
Organization: OPTEYA
In-Reply-To: <20130818194005.GA19107@kroah.com>
References: <1376854140-16904-1-git-send-email-yann@droneaud.fr>
 <20130818194005.GA19107@kroah.com>
Message-ID: <337474112b013ace0fd0a4e1d535f13d@meuh.org>
User-Agent: Roundcube Webmail/0.9.2
X-abuse-contact: abuse@ocsa-data.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 18.08.2013 21:40, Greg Kroah-Hartman a écrit :
> On Sun, Aug 18, 2013 at 09:29:00PM +0200, Yann Droneaud wrote:
> 
> Ugh, sorry about that, I thought there used to be a stringify() macro
> that used to do this.  Nice patch, I'll queue it up.
> 

That's __stringify() which is defined in <linux/stringify.h> but:
1) inside a string (eg "__stringify(vendor)") it's gonna never work;
2) it's not required here, __stringify(vendor) would be needed
    if vendor was itself a macro and the macro content was to be
    converted to a string.

Regards.

-- 
Yann Droneaud
OPTEYA

