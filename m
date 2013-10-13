Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab3JMDPH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 23:15:07 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:36211 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab3JMDPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 23:15:05 -0400
MIME-Version: 1.0
In-Reply-To: <5259B6F8.3070701@roeck-us.net>
References: <5259B6F8.3070701@roeck-us.net>
Date: Sat, 12 Oct 2013 22:15:03 -0500
Message-ID: <CAL_Jsq+wBGV6KGo4Ngrxr4_aZ=0eWPTbt0n4bhhrpERB55bQyg@mail.gmail.com>
Subject: Re: Usage of for_each_child_of_node()
From: Rob Herring <robherring2@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 12, 2013 at 3:54 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> Hi all,
>
> for_each_child_of_node() and similar functions increase the refcount
> on each returned node and expect the caller to release the node by
> calling of_node_put() when done.
>
> Looking through the kernel code, it appears this is hardly ever done,
> if at all. Some code even calls of_node_get() on returned nodes again.
>
> I guess this doesn't matter in cases where devicetree is a static entity.
> However, this is not (or no longer) the case with devicetree overlays,
> or more generically in cases where devicetree nodes are added and
> removed dynamically.
>
> Fundamental question: Would patches to fix this problem be accepted upstream
> ?

Certainly.

> Or, of course, stepping a bit back: Am I missing something essential ?

No. I think this is frequently wrong since it typically doesn't matter
for static entries as you mention.

Rob
