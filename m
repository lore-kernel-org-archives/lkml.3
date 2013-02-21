Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab3BUSVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:21:49 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:61602 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab3BUSVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:21:47 -0500
MIME-Version: 1.0
In-Reply-To: <1361469979.29360.75.camel@falcor1>
References: <alpine.LRH.2.02.1302220058500.18199@tundra.namei.org>
	<CA+55aFzkBA6bdLe73PKBaQNfV1m-JqSddF24-F-s1rX3oRE2Lg@mail.gmail.com>
	<1361469979.29360.75.camel@falcor1>
Date: Thu, 21 Feb 2013 10:21:46 -0800
X-Google-Sender-Auth: bkUSvnw93iR83EXCtYlt8aJz0hg
Message-ID: <CA+55aFxSgVX=d5RvL0kSTm5KQR-AJ=+t_+jXv9J+J3f-C4MOfA@mail.gmail.com>
Subject: Re: [GIT] Security subsystem updates for 3.9
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: James Morris <jmorris@namei.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 10:06 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>
> Almost, and enforcing file integrity is enabled.  The merged result
> should look like what's contained in
> linux-integrity/next-upstreamed-patches:
>
> int ima_module_check(struct file *file)
> {
>         if (!file) {
>                 if ((ima_appraise & IMA_APPRAISE_MODULES) &&
>                     (ima_appraise & IMA_APPRAISE_ENFORCE)) {
> #ifndef CONFIG_MODULE_SIG_FORCE
>                         return -EACCES; /* INTEGRITY_UNKNOWN */
> #endif
>                 }
>                 return 0;

Ugh. The placement of that #ifndef is just horrible, please don't do
that. Just add it around the whole if-statement rather than around
just the return. Not because the compiler can't optimize away the
tests, but because it's much more obvious to a *human* what the ifndef
actually does.

Anyway, I don't have the IMA_APPRAISE_ENFORCE bit checking, it wasn't
obvious from the conflict, so somebody will need to add that.

           Linus
