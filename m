Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab3CBBWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 20:22:46 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:47291 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab3CBBWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 20:22:45 -0500
MIME-Version: 1.0
Date: Fri, 1 Mar 2013 17:22:44 -0800
Message-ID: <CAGXu5jK7x+gFKgCN5=ZF+kSc4xSNbGtSERHCoOnCEgiJ1_wNGg@mail.gmail.com>
Subject: user ns: arbitrary module loading
From: Kees Cook <keescook@google.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Brad Spengler <spender@grsecurity.net>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rearranging done for user ns has resulted in allowing arbitrary
kernel module loading[1] (i.e. re-introducing a form of CVE-2011-1019)
by what is assumed to be an unprivileged process.

At present, it does look to require at least CAP_SETUID along the way
to set up the uidmap (but things like the setuid helper newuidmap
might soon start providing such a thing by default).

It might be worth examining GRKERNSEC_MODHARDEN in grsecurity, which
examines module symbols to verify that request_module() for a
filesystem only loads a module that defines "register_filesystem"
(among other things).

-Kees

[1] https://twitter.com/grsecurity/status/307473816672665600

--
Kees Cook
Chrome OS Security
