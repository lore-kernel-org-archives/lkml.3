Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144Ab3J1PZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:25:18 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:45626 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756547Ab3J1PZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 11:25:16 -0400
Date: Mon, 28 Oct 2013 08:25:11 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: David Miller <davem@davemloft.net>
Cc: zwu.kernel@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wuzhy@linux.vnet.ibm.com
Subject: Re: [PATCH 1/3] vxlan: silence one build warning
Message-ID: <20131028082511.2433d645@nehalam.linuxnetplumber.net>
In-Reply-To: <20131028.003807.1591686723281776238.davem@davemloft.net>
References: <1382687360-27794-1-git-send-email-zwu.kernel@gmail.com>
	<20131025084134.6cfa153a@samsung-9>
	<20131028.003807.1591686723281776238.davem@davemloft.net>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Oct 2013 00:38:07 -0400 (EDT)
David Miller <davem@davemloft.net> wrote:

> From: Stephen Hemminger <stephen@networkplumber.org>
> Date: Fri, 25 Oct 2013 08:41:34 -0700
> 
> > I would rather not fix the warning this way since it risks masking
> > later bugs if this code ever changes.
> 
> But this is suboptimally coded, and is asking for the warning.
> 
> Anything returning a pointer by reference is asking for trouble
> in my opinion.
> 
> The correct thing to do is to make create_v{4,6}_sock() return
> the "struct socket *" as an error pointer.
> 
> No more ambiguous initializations, no more warnings.

Agreed, original code used ERR_PTR (see vxlan_socket_create),
the side effect stuff only came with the addition of IPv6.
