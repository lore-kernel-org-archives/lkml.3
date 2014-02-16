Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbaBPS57 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 13:57:59 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:40209 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbaBPS55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 13:57:57 -0500
Date: Sun, 16 Feb 2014 10:57:54 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: netdev@vger.kernel.org, xen-devel@lists.xenproject.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        bridge@lists.linux-foundation.org
Subject: Re: [RFC v2 1/4] bridge: enable interfaces to opt out from becoming
 the root bridge
Message-ID: <20140216105754.63738163@nehalam.linuxnetplumber.net>
In-Reply-To: <1392433180-16052-2-git-send-email-mcgrof@do-not-panic.com>
References: <1392433180-16052-1-git-send-email-mcgrof@do-not-panic.com>
	<1392433180-16052-2-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Feb 2014 18:59:37 -0800
"Luis R. Rodriguez" <mcgrof@do-not-panic.com> wrote:

> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> It doesn't make sense for some interfaces to become a root bridge
> at any point in time. One example is virtual backend interfaces
> which rely on other entities on the bridge for actual physical
> connectivity. They only provide virtual access.
> 
> Device drivers that know they should never become part of the
> root bridge have been using a trick of setting their MAC address
> to a high broadcast MAC address such as FE:FF:FF:FF:FF:FF. Instead
> of using these hacks lets the interfaces annotate its intent and
> generalizes a solution for multiple drivers, while letting the
> drivers use a random MAC address or one prefixed with a proper OUI.
> This sort of hack is used by both qemu and xen for their backend
> interfaces.
> 
> Cc: Stephen Hemminger <stephen@networkplumber.org>
> Cc: bridge@lists.linux-foundation.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>

This is already supported in a more standard way via the root
block flag.

