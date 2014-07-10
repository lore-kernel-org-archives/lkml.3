Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaGJQWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 12:22:22 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:62395 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaGJQWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 12:22:21 -0400
Message-ID: <53BEBDB7.9080302@suse.cz>
Date: Thu, 10 Jul 2014 18:22:15 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: tty: Remove redundant memset() in initialize_tty_struct
References: <1405008984-12307-1-git-send-email-linux@rasmusvillemoes.dk>
In-Reply-To: <1405008984-12307-1-git-send-email-linux@rasmusvillemoes.dk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2014 06:16 PM, Rasmus Villemoes wrote:
> All callers (all two) of initialize_tty_struct() have just obtained
> the passed tty_struct from alloc_tty_struct(), which uses
> kzalloc(). So there is no reason to clear the memory again.

Actually I don't see a reason to have initialize_tty_struct as a
separate function. In both cases it is called after alloc_tty_struct. So
it would make sense to move the initialization to alloc_tty_struct. (And
move try_module_get before alloc_tty_struct in pty_common_install.)

Could you do that?

-- 
js
suse labs
