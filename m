Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664Ab3BIN6r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 08:58:47 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:59111 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757149Ab3BIN6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 08:58:46 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 00/33] Sanitize devm_request_and_ioremap()
To: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
Date: Sat, 09 Feb 2013 13:58:42 +0000
Message-Id: <20130209135842.5D8D83E30EC@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jan 2013 11:08:53 +0100, Thierry Reding <thierry.reding@avionic-design.de> wrote:
> Recent discussions about the lack of a meaningful error code returned by
> devm_request_and_ioremap() have triggered this patch series. One common
> issue is that the function returns NULL in all failure cases, making it
> impossible to determine what went wrong exactly. Another problem is that
> people can't seem to agree on what error code to return in case where
> the function fails. Both of these problems lead to inconsistent usage.
> 
> This series attempts to fix this by providing a replacement function,
> devm_ioremap_resource(), which returns a pointer to the remapped memory
> region on success and an ERR_PTR()-encoded error code on failure. Users
> can check for failure using the IS_ERR() macro and determine the exact
> cause by extracting the error code using PTR_ERR().
> 
> Patch 1 adds the new devm_ioremap_resource() function, which is really
> just a renamed version of devm_request_and_ioremap() that returns
> ERR_PTR()-encoded error codes on failure and makes the old function a
> wrapper around it, returning NULL in case of devm_ioremap_resource()
> failure. Furthermore the patch marks devm_request_and_ioremap() as a
> deprecated function to make it clear that it should no longer be used.
> A semantic patch is included that was used to convert the bulk of the
> existing calls to devm_request_and_ioremap() to the new API. The patch
> is far from perfect and a few occurrences had to be converted or fixed
> up manually.
> 
> The remaining patches convert each subsystem separately to use the new
> API.
> 
> Thierry

I know that this series has wide support and will probably be merged,
but I'm reply to this for the record. I do not think the ERR_PTR pattern
is a good idea because it goes against expectations of what is and is
not a valid pointer.

Nacked-by: Grant Likely <grant.likely@secretlab.ca>

Greg, if you're merging this series then don't let my objection inhibit
spi & gpio changes. I may not be happy, but I won't be an ass about it.

g.
