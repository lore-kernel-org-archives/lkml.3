Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab3HEUnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:43:40 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:50735 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab3HEUni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:43:38 -0400
MIME-Version: 1.0
In-Reply-To: <52000942.9010702@schaufler-ca.com>
References: <52000942.9010702@schaufler-ca.com>
Date: Mon, 5 Aug 2013 13:43:37 -0700
X-Google-Sender-Auth: BxQdvIlFkaH4mIfZzO6mxv0pYfo
Message-ID: <CA+55aFyii4yLORxxXKME6DgtmBsFbh8yN5SZjvDHLNOpj2+PqA@mail.gmail.com>
Subject: Re: [PATCH] Smack: IPv6 casting error fix for 3.11
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: James Morris <jmorris@namei.org>, LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why does this have the (largely same) commit message twice?

                Linus

On Mon, Aug 5, 2013 at 1:21 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
> Subject: [PATCH] Smack: IPv6 casting error fix for 3.11
>
> The original implementation of the Smack IPv6 port based
> local controls works most of the time using a sockaddr as
> a temporary variable, but not always as it overflows in
> some circumstances. The correct data is a sockaddr_in6.
> A struct sockaddr isn't as large as a struct sockaddr_in6.
> There would need to be casting one way or the other. This
> patch gets it the right way.
>
> This problem required some effort to make occur in development
> with 3.10, but hits every time in 3.11. This patch should go
> into 3.11.
>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
>
> ---
> Subject: [PATCH] Smack: IPv6 casting error fix
>
> The original implementation of the Smack IPv6 port based
> local controls works most of the time using a sockaddr as
> a temporary variable, but not always as it overflows in
> some circumstances. The correct data is a sockaddr_in6.
> A struct sockaddr isn't as large as a struct sockaddr_in6.
> There would need to be casting one way or the other. This
> patch gets it the right way.
>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
>
> ---
>  security/smack/smack_lsm.c |   24 +++++++++++-------------
>  1 files changed, 11 insertions(+), 13 deletions(-)
