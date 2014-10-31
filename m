Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648AbaJaX0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 19:26:19 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:51099 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbaJaX0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 19:26:17 -0400
MIME-Version: 1.0
In-Reply-To: <20141031214949.GA644@thunk.org>
References: <20141031214949.GA644@thunk.org>
Date: Fri, 31 Oct 2014 16:26:16 -0700
X-Google-Sender-Auth: f8y5kNx94-rYthMdQQYogqOPAYQ
Message-ID: <CA+55aFwiFx6ejtnEvZYJewHaskwjTr39bPstFvWYimqi6hMCsQ@mail.gmail.com>
Subject: Re: [GIT PULL] ext4 bug fixes for 3.18
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 2:49 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> Theodore Ts'o (1):
>       jbd2: use a better hash function for the revoke table

Does it really make sense to use hash_u64()? It can be quite expensive
(mainly on 32-bit targets), and since the low bits are where all the
information is anyway, I'd suggest using hash_32() here even if the
block number in theory can have a few bits above the 32-bit mark.

Anyway, pulled, but I just reacted to that small detail.

                      Linus
