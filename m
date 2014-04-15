Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbaDOPGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 11:06:38 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44929 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbaDOPGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 11:06:35 -0400
Date: Tue, 15 Apr 2014 16:06:26 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Emmanuel Colbus <ecolbus@manux.info>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][5/11][MANUX] Kernel compatibility : major/minor numbers
Message-ID: <20140415160626.322e24ee@alan.etchedpixels.co.uk>
In-Reply-To: <534D3762.4010905@manux.info>
References: <534D3762.4010905@manux.info>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In order to associate devices to their files, the Linux kernel uses
> their major and minor numbers. However, mine doesn't; instead, I've
> attributed myself a single group of values (major=0, minor=0, for both
> character-mode and block-mode special files), with the meaning (for the
> userspace) "you cannot identify the content of this file based on its
> major and minor numbers".

If you are using the Linux ABI then you'll hit cases (in particular tty
cases) where the ABI/API knows about major/minor numbers. In addition the
standards and common sense together pretty much imply that you need each
device to at least have a unique identifier.

Finally you need major/minor numbers to NFS serve to a diskless client.

Most Linux device numbering beyond that is basically dynamic so it
probably does't matter that much for things you concoct - providing in
som cases your /proc table of major numbers is right.

