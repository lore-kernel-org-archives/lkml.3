Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab3FZMnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:43:15 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:45652 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751368Ab3FZMnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:43:14 -0400
Message-ID: <51CAE1DD.8070301@hurleysoftware.com>
Date: Wed, 26 Jun 2013 08:43:09 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: channing <chao.bi@intel.com>
CC: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY: memory leakage in tty_buffer_find()
References: <1372236670.2390.12.camel@bichao>
In-Reply-To: <1372236670.2390.12.camel@bichao>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 04:51 AM, channing wrote:
>
> In tty_buffer_find(), it scans all tty buffers in
> free buffer queue, if it finds matched one,
> tty->buf.free will point to matched one's next buffer,
> so tty buffers that ahead of matched one are removed
> from free queue, they will never be used but they
> are not released, then memory leak happen.

Actually, the whole scan loop is wrong: only tty buffers of
size 256 are added to the free list.

So this can't leak because a buffer will never be found
mid-list.

Greg has a patch series from me that reduces this but it's not
yet in next.

Regards,
Peter Hurley

