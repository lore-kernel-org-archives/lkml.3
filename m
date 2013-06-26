Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab3FZIzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:55:44 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:63557 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3FZIzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:55:40 -0400
Message-ID: <51CAAC88.7070106@suse.cz>
Date: Wed, 26 Jun 2013 10:55:36 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: channing <chao.bi@intel.com>, gregkh@linuxfoundation.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY: memory leakage in tty_buffer_find()
References: <1372236670.2390.12.camel@bichao>
In-Reply-To: <1372236670.2390.12.camel@bichao>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 10:51 AM, channing wrote:
> 
> In tty_buffer_find(), it scans all tty buffers in
> free buffer queue, if it finds matched one,
> tty->buf.free will point to matched one's next buffer,

Oh, how is that true? tbh is moved with every iteration, right? Then:
  *tbh = t->next;
't' is what we return, 't->next' is the next one and '*tbh' is where
'next' of the previous one will point. So we just set it so we remove
't' from the list, or am I missing something?

-- 
js
suse labs
