Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964780Ab3CSUfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:35:48 -0400
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:53372 "EHLO
	mail.izyk.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757352Ab3CSUfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:35:45 -0400
Message-ID: <5148CA11.3010106@izyk.ru>
Date: Wed, 20 Mar 2013 00:26:57 +0400
From: Ilya Zykov <linux@izyk.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 6/7] n_tty: Fix unsafe update of available buffer space
References: <20130319141017.GB24900@kroah.com> <1363703218-32333-1-git-send-email-peter@hurleysoftware.com> <1363703218-32333-3-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1363703218-32333-3-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.03.2013 18:26, Peter Hurley wrote:
> receive_room is used to control the amount of data the flip
> buffer work can push to the read buffer. This update is unsafe:
> 
>   CPU 0                        |  CPU 1
>                                |
>                                | n_tty_read()
>                                |   n_tty_set_room()
>                                |     left = <calc of space>
> n_tty_receive_buf()            |
>   <push data to buffer>        |
>   n_tty_set_room()             |
>     left = <calc of space>     |
>     tty->receive_room = left   |
>                                |     tty->receive_room = left
> 
> receive_room is now updated with a stale calculation of the
> available buffer space, and the subsequent work loop will likely
> overwrite unread data in the input buffer.
> 

Sounds reasonable to me.
Thank you.
Ilya Zykov <linux@izyk.ru>



