Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab3ICSQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 14:16:26 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:49809 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab3ICSQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 14:16:25 -0400
MIME-Version: 1.0
Date: Tue, 3 Sep 2013 14:16:24 -0400
Message-ID: <CANP1eJFCtZphaiZXz74421L8NY6Ggjek48sU+=qKD0tkVBbQmg@mail.gmail.com>
Subject: Question on vma_operations readpages and locking
From: Milosz Tanski <milosz@adfin.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can anyone help me reason about the readpages() callback in vma_operations?

Do the pages that come in the argument list from readahead come
locked? The documentation in the kernel says nothing about locking on
the way in (Documentation/filesystems/Locking) unlike readpage. It
does say that the pages should be unlocked when the operation is done.

Should I assume that the readpages implementer needs to take care to
lock those pages her / his self?

I've been reading through the code for different filesystems to
understand what should happen but I'm not a 100% clear on it. Thanks
in advance,

- Milosz
