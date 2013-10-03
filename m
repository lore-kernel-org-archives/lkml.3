Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab3JCWYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 18:24:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50803 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755652Ab3JCWYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 18:24:13 -0400
Message-ID: <524DEE6B.2060105@zytor.com>
Date: Thu, 03 Oct 2013 15:23:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        kernel-hardening@lists.openwall.com, adurbin@google.com,
        Eric Northup <digitaleric@google.com>, jln@google.com, wad@google.com,
        Mathias Krause <minipli@googlemail.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH 3/7] x86, kaslr: find minimum safe relocation position
References: <1380833605-26313-1-git-send-email-keescook@chromium.org> <1380833605-26313-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1380833605-26313-4-git-send-email-keescook@chromium.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2013 01:53 PM, Kees Cook wrote:
> Examine all the known unsafe areas and avoid them by just raising the
> minimum relocation position to be past them.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

> +	/* Minimum location must be above all these regions: */

This is highly problematic.  The standard protocol is to hoist the
initramfs as high as possible in memory, so this may really unacceptably
restrict the available range.

It would be better to treat these the same as reserved regions in the
e820 map as far as the address space picking algorithm is concerned.

	-hpa


