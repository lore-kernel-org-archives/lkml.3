Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934396AbaLKU4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 15:56:15 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:47393 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934584AbaLKUz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 15:55:29 -0500
MIME-Version: 1.0
In-Reply-To: <54899F0E.4090309@ti.com>
References: <54899F0E.4090309@ti.com>
Date: Thu, 11 Dec 2014 12:55:28 -0800
X-Google-Sender-Auth: A1O19dA5l5C7hjHKrz1v1Skk5E4
Message-ID: <CA+55aFyPauetupuqp0aexH2-2Z638jp-s_jyarvZW_sCSizzsg@mail.gmail.com>
Subject: Re: [GIT PULL] fbdev fixes for 3.19
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 5:41 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
>
> Please pull fbdev changes for 3.19.

Ugh. I've pulled it, but I'm not a huge fan of commit 6d09dc6b74ca
("of.h: Keep extern declaration of of_* variables when !CONFIG_OF").

I guess it works, but it ends up delaying any failures from compile
time to link time, and the linker error messages likely won't be
great.

So I'm cc'ing the OF people and Rafael (who worked on OF/ACPI
unification) to see if they have comments, preferences, or other ways
to solve this.

Quite frankly, to me it smells like non-OF builds should just have an
empty "for_each_child_of_node ()" define instead of playing games with
externs that then end up not existing, and depending on the compiler
DTRT.

Comments?

                      Linus
