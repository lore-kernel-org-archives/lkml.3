Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbaLGUlf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 15:41:35 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:52590 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbaLGUlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 15:41:32 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Bjorn Helgaas <bhelgaas@google.com>, kernel-janitors@vger.kernel.org,
        joe@perches.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/20] PCI: fix misspelling of current function in string
Organization: D03
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
	<1417980062-25151-4-git-send-email-Julia.Lawall@lip6.fr>
X-Hashcash: 1:20:141207:joe@perches.com::WjV9eCjYDEXdWUqk:000+0N
X-Hashcash: 1:20:141207:linux-kernel@vger.kernel.org::0V+2cDbLFVBy+3ob:0000000000000000000000000000000002Rpc
X-Hashcash: 1:20:141207:bhelgaas@google.com::V7zte8+sKQ5HtDVk:0000000000000000000000000000000000000000002aGe
X-Hashcash: 1:20:141207:linux-pci@vger.kernel.org::Nsqlx7UzDd850VjQ:0000000000000000000000000000000000003yOc
X-Hashcash: 1:20:141207:kernel-janitors@vger.kernel.org::bIkTLIlqbFor2+HK:0000000000000000000000000000005rUl
X-Hashcash: 1:20:141207:julia.lawall@lip6.fr::Ad8FQfjPowMNb+Zg:000000000000000000000000000000000000000009f4I
Date: Sun, 07 Dec 2014 21:41:28 +0100
In-Reply-To: <1417980062-25151-4-git-send-email-Julia.Lawall@lip6.fr> (Julia
	Lawall's message of "Sun, 7 Dec 2014 20:20:45 +0100")
Message-ID: <87lhmj42h3.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07 2014, Julia Lawall <Julia.Lawall@lip6.fr> wrote:

> Replace a misspelled function name by %s and then __func__.
>
> The function name begins with pci, not cpci.
...
>  	result = cpci_hotplug_init(debug);
>  	if (result) {
> -		err("cpci_hotplug_init with error %d\n", result);
> +		err("%s with error %d\n", __func__, result);
>  		return result;
>  	}

This one seems to be a false positive; I think the err() is reporting on
the result from the call of the function which is indeed called
cpci_hotplug_init.

I just skimmed the rest quickly, but they seem ok.

Rasmus
