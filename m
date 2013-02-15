Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761163Ab3BOK4C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 05:56:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760856Ab3BOK4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 05:56:00 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1360899751-24377-1-git-send-email-peterhuewe@gmx.de>
References: <1360899751-24377-1-git-send-email-peterhuewe@gmx.de>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: dhowells@redhat.com, Willy Tarreau <willy@meta-x.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshiaki Yamane <yamanetoshi@gmail.com>,
        Adam Buchbinder <adam.buchbinder@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/panel: Mark local functions as static (fix smatch warnings)
Date: Fri, 15 Feb 2013 10:55:45 +0000
Message-ID: <12246.1360925745@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Huewe <peterhuewe@gmx.de> wrote:

> +static char old_keypad_profile[][4][9] = {
>  	{"S0", "Left\n", "Left\n", ""},
>  	{"S1", "Down\n", "Down\n", ""},
>  	{"S2", "Up\n", "Up\n", ""},

Things like this should likely be const also.  There are several here.

> -void panel_lcd_print(char *s)
> +static void panel_lcd_print(char *s)

const char *s maybe?

David
