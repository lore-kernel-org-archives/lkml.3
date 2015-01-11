Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbbAKWXH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:23:07 -0500
Received: from ares60.inai.de ([5.9.23.85]:47460 "EHLO ares60.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbbAKWXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:23:05 -0500
Date: Sun, 11 Jan 2015 23:23:01 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: Richard Weinberger <richard@nod.at>
cc: Joe Perches <joe@perches.com>,
        Netfilter Developer Mailing List 
	<netfilter-devel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Networking Developer Mailing List 
	<netdev@vger.kernel.org>
Subject: Re: [PATCH 3/3] x_tables: Factor out 16bit aligment
 ifname_compare()
In-Reply-To: <54B2EB81.5050604@nod.at>
Message-ID: <alpine.LSU.2.11.1501112257580.10101@nerf60.vanv.qr>
References: <1421009571-5279-1-git-send-email-richard@nod.at>  <1421009571-5279-4-git-send-email-richard@nod.at>  <1421009969.9233.5.camel@perches.com> <54B2E4DD.90200@nod.at> <1421010853.9233.7.camel@perches.com> <54B2EB81.5050604@nod.at>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2015-01-11 22:30, Richard Weinberger wrote:
>>>> Perhaps this would be better as bool ifname_compare
>
>Anyway, I agree with Linus wrt. bool.
>https://lkml.org/lkml/2013/8/31/138

Had the function return "bool", it would have been obvious enough
what to do with its return type. A return type of "int" might have
hinted towards negative-is-error (in general) or strcmpish values
(functions doing string compare work).

Now that it returns "unsigned long", one is pressed to look at the 
function body (not bad per se, but it is a hump) for the return 
value's semantics.

Linus says bool is dangerous to the unsuspecting user — but so is
"volatile", microwave ovens, etc. If the kernel really cared for
entry-level coders, it would be written in something like MISRA C.
