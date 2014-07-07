Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbaGGPk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:40:59 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:58020 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaGGPk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:40:58 -0400
MIME-Version: 1.0
In-Reply-To: <1403782279-10116-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1403782279-10116-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Mon, 7 Jul 2014 17:40:57 +0200
Message-ID: <CACRpkdbUAnSFAJMM4hewTA7+KsvZ5T_X5mmjzoFtJ9wAZYix2w@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pinctrl-msm.c: Cleaning up if unsigned is less
 than zero
From: Linus Walleij <linus.walleij@linaro.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 1:31 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:

> Remove checking if a unsigned is less than zero
>
> This was found using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
(...)
> -       if (WARN_ON(g->mux_bit < 0))
> +       if (WARN_ON(g->mux_bit != 0))

Is that correct?

If the variable cannot be < 0 should the check not simply be
deleted, since this is all it checks for?

Yours,
Linus Walleij
