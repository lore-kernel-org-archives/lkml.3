Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab3GDSPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 14:15:23 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:43686 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab3GDSPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 14:15:21 -0400
Subject: Re: [problem?] swapon: swap partition/volume size capped at 32G?
From: Raymond Jennings <shentino@gmail.com>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1372886473.1079.3.camel@warfang>
References: <1372886473.1079.3.camel@warfang>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Jul 2013 11:15:10 -0700
Message-ID: <1372961710.16288.1.camel@warfang>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-03 at 14:21 -0700, Raymond Jennings wrote:
> Ok, so I just upgraded to 3.10.0 (gentoo system) and made a nice big
> 64GiB swap volume on lvm as usual.
> 
> Suddenly, swapon doesn't recognize more than 32GiB, as top lists only
> that much swap space.
> 
> swapon using *two* separate 32GiB partitions works fine, but for some
> reason a swap partition bigger than 32GiB isn't fully recognized.
> 
> Previous kernel versions IIRC recognized the entire swap partition.
> 
> Is something wrong or is this new behavior standard?
> 
Hold on a minute, I just found out something ate my kernel config and
turned off PAE when I upgraded.

This in turn shrunk my pte's from 64 bits to 32 bits and is probably
what killed >32G swap extents.


