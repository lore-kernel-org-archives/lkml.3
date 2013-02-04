Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab3BDAdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 19:33:18 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43381 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab3BDAdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 19:33:15 -0500
MIME-Version: 1.0
Date: Mon, 4 Feb 2013 10:33:15 +1000
Message-ID: <CAPM=9tyyR2YkaFPHQGy_mU9YM87uaQ79Cgxvy=-ZfAAuxcSj+g@mail.gmail.com>
Subject: pci_lock and runtime resume
From: Dave Airlie <airlied@gmail.com>
To: linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I've just been looking a bit more at dynamic PM for graphics and
noticed that when userspace reads pci config space, the read happens
under the pci_lock which is a spinlock.
Now on most of the GPU drivers we'll be entering standard s/r paths
which don't have this restriction from what I can see, I get to see
lots of scheduling while atomic fun, that I'm not really sure I can
fix nicely.

Dave.
