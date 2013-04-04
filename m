Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762946Ab3DDQ0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:26:14 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:60146 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760890Ab3DDQ0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:26:12 -0400
MIME-Version: 1.0
Reply-To: linasvepstas@gmail.com
In-Reply-To: <1365033776-21804-5-git-send-email-rkuo@codeaurora.org>
References: <1365033776-21804-1-git-send-email-rkuo@codeaurora.org> <1365033776-21804-5-git-send-email-rkuo@codeaurora.org>
From: Linas Vepstas <linasvepstas@gmail.com>
Date: Thu, 4 Apr 2013 11:25:50 -0500
Message-ID: <CAHrUA37oTkv-x5f4zZVwqjWAqvyMdwXAokw1EDBHiGv8ozWxVQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] Hexagon: check to if we will overflow the signal stack
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 April 2013 19:02, Richard Kuo <rkuo@codeaurora.org> wrote:

> +       /* check if we would overflow the alt stack */
> +       if (on_sig_stack(sp) && !likely(on_sig_stack(sp - frame_size)))
> +               return (void __user __force *)-1UL;

I found the !likely construction confusing, as its doing both a
'unlikely' (right?) and inverting the argument. It seems clearer,
to idiots like me, to write this as:

if (on_sig_stack(sp) && unlikely(!on_sig_stack(sp - frame_size)))

since where checking for overflow, and its unlikely that the overflow happened.

-- Linas
